class ArtworkArchiveBulkSpider < Spider
  URL = "https://www.artworkarchive.com/call-for-entry".freeze

  @name = "artwork_archive_bulk_spider"
  @engine = :selenium_chrome
  @start_urls = [URL]

  def parse(response, url:, data: {})
    while next_page_link
      next_page_link.click
      sleep 1
      add_all_calls
    end
  end

  private

  def add_all_calls
    call_list.each do |call_container|
      @call = ::Call.find_or_initialize_by(
        user: User.system,
        external_url: call_container.find(:xpath, '..')[:href], # finding child div for now
        external: true,
        spider: :artwork_archive
      )

      @call.call_type_id = :unspecified if @call.new_record?
      save_with_admins
    end
  end

  def call_list
    result = browser.all("//div[@class='call-container call-container-featured']").to_a
    result += browser.all("//div[@class='call-container call-container-basic']").to_a
    result
  end

  def next_page_link
    browser.all("//li[@class='waves-effect']//a//i[@class='fa fa-angle-right']")&.first
  end
end
