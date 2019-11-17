class CallForEntrySpider < Kimurai::Base
  URL = "https://artist.callforentry.org/festivals.php?reset=1&apply=yes".freeze

  @name = "call_for_entry_spider"
  @engine = :selenium_chrome
  @start_urls = [URL]

  def parse(response, url:, data: {})
    choose_call_type
    choose_eligibility if eligibility_filter
    choose_sort_option if sort_option

    call_count = 0
    attempt_count = 0

    until call_count == max_call_count || attempt_count == max_attempt_count
      return if browser.all(:xpath, "//*[text() = 'MORE INFO']")[attempt_count].nil?

      browser.all(:xpath, "//*[text() = 'MORE INFO']")[attempt_count].click

      if create_maybe
        call_count += 1
      end

      attempt_count += 1
      browser.go_back
    end
  end

  private

  def choose_call_type
    browser.find(:xpath, "//*[@id='call-icon']").click
    filter_checkbox(call_type).click
    browser.find(:xpath, "//*[@id='call-icon']").click
  end

  def choose_eligibility
    browser.find(:xpath, "//*[@id='elig-icon']").click
    filter_checkbox(eligibility_filter).click
    browser.find(:xpath, "//*[@id='elig-icon']").click
  end

  def choose_sort_option
    browser.select sort_option, from: 'sort'

    # TODO support state sort

    if sort_option == 'DEADLINE'
      deadline_sort_labels.find { |element| element.text == deadline_sort_by }.click
    end
  end

  def filter_checkbox(checkbox_name)
    browser.all(:xpath, "//label[@class='ck-contain']").find do |ck_contain|
      ck_contain.text == checkbox_name
    end
  end

  def create_maybe
    return if User.system.calls.where(external_url: browser.current_url).exists?

    event_dates = browser.text.split('Event Dates:').last.strip.split('Entry Deadline').first.split(' - ')
    # TODO: report but continue when this fails. some will not have dates.

    deadline_str = browser.text.split('Entry Deadline:').last.strip.split('D').first

    eligibility = \
      browser.text.split('Eligibility:').last.strip.
        match(/^(?:International|National|Regional|Local|Unspecified)/)&.to_s&.downcase

    User.system.calls.create(
      user: User.system,
      external: true,
      external_url: browser.current_url,
      call_type_id: call_type_id,
      name: browser.find(:xpath, "//*[@class='fairname']").text,
      start_at: Date.strptime(event_dates.first, "%m/%d/%y"),
      end_at: Date.strptime(event_dates.last, "%m/%d/%y"),
      application_deadline: Date.strptime(deadline_str, "%m/%d/%y"),
      overview: possible_overview&.text || "View details to find out more...",
      eligibility: eligibility
    ).persisted?
  rescue => e
    Rails.logger.debug e.message
    puts e.message
    false
  end

  def possible_overview
    browser.all(:xpath, "//p").find do |paragraph|
      paragraph.text.include?('eligible') ||
        paragraph.text.include?('open to') ||
        paragraph.text.include?('invite') ||
        paragraph.text.include?('present')
    end
  end

  def call_type
    ENV['call_type'] || "Exhibitions"
  end

  def call_type_id
    case call_type
    when "Exhibitions"
      'exhibition'
    when "Residencies"
      'residency'
    end
  end

  def eligibility_filter
    return if ENV['ignore_eligibility'].present?

    ENV['eligibility'] || "International"
  end

  def max_call_count
    ENV['max_call_count']&.to_i || 10
  end

  def max_attempt_count
    ENV['max_attempt_count']&.to_i || 40
  end

  def sort_option
    return if ENV['ignore_sort_option'].present?

    ENV['sort_option'] || 'DEADLINE'
  end

  def deadline_sort_labels
    browser.all(:xpath, "//div[@id='deadline-types']//label[@class='r-contain']")
  end

  def deadline_sort_by
    ENV['deadline_sort_by'] || "Latest Deadline"
  end
end
