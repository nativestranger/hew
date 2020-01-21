class ArtworkArchiveSpider < Kimurai::Base
  URL = "https://www.artworkarchive.com/call-for-entry".freeze

  @name = "artwork_archive_spider"
  @engine = :selenium_chrome
  @start_urls = [URL]

  def parse(response, url:, data: {})
    @call = ::Call.find(ENV['call_id'])
    browser.visit @call.external_url

    update_maybe
  end

  private

  def update_maybe
    @call.call_type_id ||= call_type_id
    @call.name = name if name && @call.name.blank?
    @call.start_at ||= start_at
    @call.end_at ||= end_at
    @call.entry_deadline ||= entry_deadline
    @call.description ||= possible_description&.text || ''
    @call.eligibility ||= eligibility
    @call.entry_fee ||= entry_fee_in_cents

    @call.save!
  rescue => e
    Rails.logger.debug e.message
    false
  end

  def name
    call_hero_container.find(:xpath, "//h2").text.strip
  rescue => e
    nil
  end

  def event_dates
    browser.text.split('Event Dates:').last.strip.split(/(?:Entry|Type\:)/).first.strip.split(' - ')
  rescue => e
    nil
  end

  def call_hero_container
    browser.find(:xpath, "//div[@class='call-hero-container']")
  end

  def start_at
    Date.strptime(event_dates.first, "%B %d, %Y")
  rescue => e
    nil
  end

  def end_at
    Date.strptime(event_dates.last, "%B %d, %Y")
  rescue => e
    nil
  end

  def entry_deadline # TODO: handle ongoing
    deadline_str = browser.find(:xpath, "//p[@class='call-date']").text.split(' ').first(3).join(' ')
    Date.strptime(deadline_str, "%B %d, %Y")
  end

  def eligibility
    browser.text.split('Eligibility:').last.strip.
      match(/^(?:International|National|Regional|State|Local|Unspecified)/)&.to_s&.downcase
    rescue => e
      nil
  end

  def possible_description
    call_hero_container.all(:xpath, "//div[@class='row']")[2]
  rescue => e
    nil
  end

  def entry_fee_in_cents
    # TODO: handle exceptions in euros or other... €, CAD

    browser.text.split('Fee:').
      last.strip.split(' ').first.gsub('$', '').
        match(/\A[+-]?\d+(\.[\d]+)?\z/)&.to_s&.to_f * 100
  rescue => e
    Rails.logger.debug "ENTRY FEE ERROR #{e.message}"
    nil
  end

  def call_type_id
    'unspecified' # TODO: resolve this
  end
end
