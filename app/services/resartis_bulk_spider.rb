class ResartisBulkSpider < Spider
  URL = "http://resartis.org/open-calls/".freeze

  @name = "resartis_bulk_spider"
  @engine = :selenium_chrome
  @start_urls = [URL]

  def parse(response, url:, data: {})
    call_links.each do |call_link|
      @call = ::Call.find_or_initialize_by(
        external_url: call_link[:href]
      )

      find_or_create_call
    end
  end

  def spider_name
    :resartis
  end

  def call_links
    browser.all(
      :xpath,
      "//*[@class='grid__item  postcard']//article//div//h2//a"
    ).select { |cl| cl[:href].include?('resartis.org/open-call/') }
  end
end
