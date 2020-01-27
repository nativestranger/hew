class ArtGuideSpider < Spider
  @name = "art_guide_spider"
  @engine = :selenium_chrome

  private

  def update_maybe
    # binding.pry
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

  def name
    browser.
      all(:xpath, "//*[@class='blogdt-heading']//h1")[0].text.strip
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
    deadline_str = browser.find(
      :xpath, "//p[@class='deadline']"
    ).text.split("Entry Deadline:").reject(&:blank?)[0].strip
    Date.strptime(deadline_str, "%b. %d") # Mar. 30
  end

  def eligibility
    browser.text.split('Eligibility:').last.strip.
      match(/^(?:International|National|Regional|State|Local|Unspecified)/)&.to_s&.downcase
    rescue => e
      nil
  end

  def possible_description
    browser.all(:xpath, "//div[@class='blog-details']").first.text
  rescue => e
    nil
  end

  def entry_fee_in_cents
    # TODO: handle exceptions in euros or other... €, CAD

    browser.text.downcase.split('fee:').
      last.strip.split(' ').first.gsub('$', '').
        match(/\A[+-]?\d+(\.[\d]+)?\z/)&.to_s&.to_f * 100
  rescue => e
    Rails.logger.debug "ENTRY FEE ERROR #{e.message}"
    nil
  end

  def call_type_id
    type_text = browser.text.split('Type:').last.strip

    if type_text.match(/^(?:Exhibition|Competition|Residency)/)
      type_text.match(/^(?:Exhibition|Competition|Residency)/).to_s.downcase
    elsif type_text.starts_with?("Public Art & Proposals")
      'public_art'
    end
    rescue => e
      nil
  end
end
