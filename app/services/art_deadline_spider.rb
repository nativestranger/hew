class ArtDeadlineSpider < Kimurai::Base
  URL = "https://artdeadline.com/".freeze

  @name = "art_deadline_spider"
  @engine = :selenium_chrome
  @start_urls = [URL]

  def parse(response, url:, data: {})
    browser.all(:xpath, "//*[@class='filter']//input[@type='checkbox']").each(&:click) # remove all
    browser.find(:xpath, "//*[@id='type-call']").click
    browser.find(:xpath, "//*[@class='filter']//input[@type='submit']").click

    call_count = 0
    attempt_count = 0

    until call_count == 5 || attempt_count > 20
      call_links[attempt_count].click

      if create_maybe(call_type_id: nil)
        call_count += 1
      end

      attempt_count += 1
      browser.go_back
    end
  end

  private

  def call_links
    browser.all(:xpath, "//ol[@class='jobs']//li//dl//dd[@class='title']//strong//a")
  end

  def create_maybe(call_type_id:)
    return if User.system.calls.where(external_url: browser.current_url).exists?

    deadline_str = browser.text.split("Deadline:").last.split('–').first.strip
    # TODO: handle ongoing. add a start_at && end_at presence exception

    # User.system.calls.create(
    #   user: User.system,
    #   external: true,
    #   external_url: browser.current_url,
    #   call_type_id: call_type_id,
    #   name: browser.find(:xpath, "//h1[@class='title']").text,
    #   start_at: Date.strptime(event_dates.first, "%m/%d/%y"),
    #   end_at: Date.strptime(event_dates.last, "%m/%d/%y"),
    #   application_deadline: Date.strptime(deadline_str, "%B %d, %y"),
    #   overview: possible_overview&.text || "View details to find out more..."
    # ).persisted?
  rescue => e
    Rails.logger.debug e.message
    puts e.message
    false
  end

  def possible_overview
  end
end
