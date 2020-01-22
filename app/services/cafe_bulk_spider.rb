class CafeBulkSpider < Spider
  URL = "https://artist.callforentry.org/festivals.php?reset=1&apply=yes".freeze

  @name = "cafe_bulk_spider"
  @engine = :selenium_chrome
  @start_urls = [URL]

  def parse(response, url:, data: {})
    browser.all(:xpath, "//*[text() = 'MORE INFO']").each do |entry_link|
      @call = ::Call.find_or_initialize_by(
        external_url: entry_link[:href]
      )

      save_with_admins
    end
  end

  def spider_name
    :call_for_entry
  end
end
