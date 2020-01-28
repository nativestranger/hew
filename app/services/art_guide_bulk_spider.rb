class ArtGuideBulkSpider < Spider
  URL = "https://theartguide.com/calls-for-artists".freeze

  @name = "art_guide_bulk_spider"
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
    call_links.each do |call_link|
      next unless call_link[:href].include?("theartguide.com/callforartist")

      @call = ::Call.find_or_initialize_by(
        external_url: call_link[:href]
      )

      find_or_create_call
    end
  end

  def call_links
    browser.all(:xpath, "//*[@data-content='Event']//a")
  end

  def next_page_link
    browser.all("//a[@class='next page-numbers']")&.first
  end

  def spider_name
    :art_guide
  end
end
