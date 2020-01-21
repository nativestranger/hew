class ArtDeadlineBulkSpider < Spider
  URL = "https://artdeadline.com/".freeze

  @name = "art_deadline_spider"
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

  # TODO: add job job-featured job-featured
  def call_links
    result = browser.all(
      :xpath,
      "//ol[@class='jobs']//li[@class='job']//dl//dd[@class='title']//strong//a"
    ).to_a
    result += browser.all(
      :xpath,
      "//ol[@class='jobs']//li[@class='job job-alt']//dl//dd[@class='title']//strong//a"
    ).to_a
    result
  end

  def add_all_calls
    call_links.each do |call_link|
      @call = ::Call.find_or_initialize_by(
        user: User.system,
        external_url: call_link[:href], # finding child div for now
        external: true,
        spider: :art_deadline
      )

      @call.call_type_id = :unspecified if @call.new_record?
      save_with_admins
    end
  end

  def next_page_link
    browser.all(:xpath, "//a[@class='next page-numbers']").first
  end
end
