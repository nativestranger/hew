require 'kimurai'

class CallForEntrySpider < Kimurai::Base
  URL = "https://artist.callforentry.org/festivals.php?reset=1&apply=yes".freeze

  @name = "call_for_entry_spider"
  @engine = :selenium_chrome
  @start_urls = [URL]

  def parse(response, url:, data: {})
    browser.find(:xpath, "//*[@id='call-icon']").click
    filter_checkbox("Exhibitions").click
    browser.find(:xpath, "//*[@id='call-icon']").click

    browser.find(:xpath, "//*[@id='elig-icon']").click
    filter_checkbox("International").click
    browser.find(:xpath, "//*[@id='elig-icon']").click

    call_count = 0
    attempt_count = 0

    until call_count == 5 || attempt_count > 20
      browser.all(:xpath, "//*[text() = 'MORE INFO']")[attempt_count].click
      if create_maybe(call_type_id: 'exhibition')
        call_count += 1
      end

      attempt_count += 1
      browser.go_back
    end
  end

  private

  def filter_checkbox(checkbox_name)
    browser.all(:xpath, "//label[@class='ck-contain']").find do |ck_contain|
      ck_contain.text == checkbox_name
    end
  end

  def create_maybe(call_type_id:)
    return if User.system.calls.where(external_url: browser.current_url).exists?

    event_dates = browser.text.split('Event Dates:').last.strip.split('Entry Deadline').first.split(' - ')
    deadline_str = browser.text.split('Entry Deadline:').last.strip.split('D').first

    User.system.calls.create(
      user: User.system,
      external: true,
      external_url: browser.current_url,
      call_type_id: call_type_id,
      name: browser.find(:xpath, "//*[@class='fairname']").text,
      start_at: Date.strptime(event_dates.first, "%m/%d/%y"),
      end_at: Date.strptime(event_dates.last, "%m/%d/%y"),
      application_deadline: Date.strptime(deadline_str, "%m/%d/%y"),
      overview: possible_overview&.text || "View details to find out more..."
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
end
