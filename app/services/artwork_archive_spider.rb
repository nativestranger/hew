class ArtworkArchiveSpider < Kimurai::Base
  URL = "https://www.artworkarchive.com/call-for-entry".freeze

  @name = "artwork_archive_spider"
  @engine = :selenium_chrome
  @start_urls = [URL]

  def parse(response, url:, data: {})
    apply_filters

    call_count = 0
    attempt_count = 0

    until call_count == max_call_count || attempt_count == max_attempt_count
      browser.visit(URL)
      apply_filters

      sleep 1

      if call_list[attempt_count].nil?
        Rails.logger.debug "ENDED AT #{attempt_count} ATTEMPTS"
        return
      end

      call_list[attempt_count].click
      sleep 0.5

      if create_maybe
        call_count += 1
      end

      attempt_count += 1
    end
  end

  private

  def apply_filters
    choose_call_type if call_type_filter
    # choose_eligibility if eligibility_filter
  end

  def call_list
    result = browser.all("//div[@class='call-container call-container-featured']").to_a
    result += browser.all("//div[@class='call-container call-container-basic']").to_a
    result
  end

  def filter_labels
    browser.all(:xpath, "//div[@class='calls-filter js-filters-submit']//label")
  end

  def choose_call_type
    filter_labels.find do |label|
      label.text == call_type_filter
    end.click
  end

  def choose_eligibility
    filter_labels.find do |label|
      label.text == eligibility_filter
    end.click
  end

  def call_hero_container
    browser.find(:xpath, "//div[@class='call-hero-container']")
  end

  def create_maybe
    return if User.system.calls.where(external_url: browser.current_url).exists?

    event_dates = browser.text.split('Event Dates:').last.strip.split('Entry').first.strip.split(' - ')
    # TODO: rescue but log when this fails. come won't have dates...

    deadline_str = browser.find(:xpath, "//p[@class='call-date']").text.split(' ').first(3).join(' ')

    eligibility = \
      browser.text.split('Eligibility:').last.strip.
        match(/^(?:International|National|Regional|State|Local|Unspecified)/)&.to_s&.downcase

    # TODO: add entry fee

    User.system.calls.create(
      user: User.system,
      external: true,
      external_url: browser.current_url,
      call_type_id: call_type_id,
      name: call_hero_container.find(:xpath, "//h2").text.strip,
      start_at: Date.strptime(event_dates.first, "%B %d, %Y"),
      end_at: Date.strptime(event_dates.last, "%B %d, %Y"),
      application_deadline: Date.strptime(deadline_str, "%B %d, %Y"),
      overview: possible_overview&.text || "View details to find out more...",
      eligibility: eligibility,
      is_public: true
    ).persisted?
  rescue => e
    Rails.logger.debug e.message
    false
  end

  def possible_overview
    call_hero_container.all(:xpath, "//div[@class='row']")[2]
  end

  def call_type_filter
    ENV['call_type'] || "Exhibition"
  end

  def call_type_id
    case call_type_filter
    when "Exhibition"
      'exhibition'
    when "Residency"
      'residency'
    when "Competition"
      'competition'
    end
  end

  def eligibility_filter
    return if ENV['ignore_eligibility'].present?

    ENV['eligibility'] || "International"
  end

  def max_call_count
    ENV['max_call_count']&.to_i || 20
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
