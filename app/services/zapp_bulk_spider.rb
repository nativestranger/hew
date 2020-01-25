class ZappBulkSpider < Spider
  URL = "https://www.zapplication.org/participating-events.php".freeze

  @name = "zapp_bulk_spider"
  @engine = :selenium_chrome
  @start_urls = [URL]

  def parse(response, url:, data: {})
    sleep 5 # slow page

    call_hrefs.each do |href|
      @call = ::Call.find_or_initialize_by(
        external_url: href
      )

      find_or_create_call
    end
  end

  def spider_name
    :zapplication
  end

  def call_hrefs
    browser.all(:xpath, "//body//a").
      select { |a| a[:href]&.include?('zapplication.org/event-info')}.
      map { |a| a[:href] }
  end
end
