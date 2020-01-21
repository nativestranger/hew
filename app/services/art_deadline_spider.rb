class ArtDeadlineSpider < Spider
  URL = "https://artdeadline.com/".freeze

  @name = "art_deadline_spider"
  @engine = :selenium_chrome
  @start_urls = [URL]

  # Show Dates: December 12, 2019-January 4, 2020
  # On Display: December 12, 2019-January 4, 2020

  def parse(response, url:, data: {})
    @call = ::Call.find(ENV['call_id'])
    browser.visit @call.external_url

    update_maybe
  end

  private


  def update_maybe
    @call.call_type_id = call_type_id if call_type_id && @call.call_type_id_unspecified?
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

  def possible_description
    ps = browser.all(:xpath, "//div[@class='section_content']//p").first&.text&.split(' – ')
    ps && ps[1].strip
  rescue => e
    nil
  end

  def entry_deadline
    deadline_str = browser.text.split("Deadline:").last.split('–').first.strip
    Date.strptime(deadline_str, "%B %d, %y")
  rescue => e
    nil
  end

  def call_type_id
    result = browser.all(:xpath, "//span[@class='type']").first.text

    case result
    when 'Competitions'
      'competition'
    when 'Public Art RFP'
      'public_art'
    when 'Residencies'
      'residency'
    end
  rescue => e
    nil
  end

  def name
    # TODO: this is gross.. don't do this?
    browser.find(:xpath, "//h1[@class='title']").native.text.split("\n")[1]
  rescue => e
    nil
  end

  def entry_fee_in_cents
    nil
  end

  def eligibility
    # TODO
  end

  def start_at
  end

  def end_at
  end
end
