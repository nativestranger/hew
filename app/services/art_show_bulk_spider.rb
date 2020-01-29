class ArtShowBulkSpider < Spider
  URL = "https://www.artshow.com/juriedshows/index.html".freeze
  # TODO: see if 'featured opportuniries' page has all or not

  @name = "art_show_spider"
  @engine = :selenium_chrome
  @start_urls = [URL]

  def call_containers
    browser.all(:xpath, "//*[@class='col-md-3 col-sm-4 listing col-centered']")
  end

  def call_links
    browser.all(:xpath, "//a[text() = 'More info']")
  end

  def names
    browser.all(:xpath, "//*[@class='OppTitle']")
  end

  def parse(response, url:, data: {})
    call_containers.each do |call_container|
      next unless external_url(call_container)

      @call = ::Call.find_or_initialize_by(
        external_url: external_url(call_container)
      )

      next unless @call.new_record?
      # no individual scraper for now. this site links to external sites.

      call_name = name(call_container)
      # TODO: description?

      @call.name = call_name
      @call.entry_deadline = entry_deadline(call_container)
      @call.call_type_id = call_type_id_fallback_from(call_name || '')
      @call.call_type_id ||= call_type_id_fallback_from(call_container.text)
      find_or_create_call
    end
  end

  def external_url(call_container)
    call_container.
      all(:xpath, "a[text() = 'More info']").
      first[:href]
  rescue => e
  end

  def name(call_container)
    call_container.
      all(:xpath, "//*[@class='OppTitle']").
      first.text
  end

  def entry_deadline(call_container)
    deadline_str = call_container.text.split(/deadline:/i)[1].
      split('.').first.strip

    Date.strptime(deadline_str, "%B %d, %Y")
  rescue => e
    nil
  end

  def spider_name
    :art_show
  end
end
