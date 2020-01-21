class CafeBulkSpider < Spider
  URL = "https://artist.callforentry.org/festivals.php?reset=1&apply=yes".freeze

  @name = "cafe_bulk_spider"
  @engine = :selenium_chrome
  @start_urls = [URL]

  def parse(response, url:, data: {})
    browser.all(:xpath, "//*[text() = 'MORE INFO']").each do |entry_link|
      @call = ::Call.find_or_initialize_by(
        user: User.system,
        external_url: entry_link[:href],
        external: true,
        spider: :call_for_entry
      )

      @call.call_type_id = :unspecified if @call.new_record?
      save_with_admins
    end
  end
end
