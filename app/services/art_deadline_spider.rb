class ArtDeadlineSpider < Spider
  @name = "art_deadline_spider"
  @engine = :selenium_chrome

  private


  def update_maybe
    @call.call_type_id = call_type_id if call_type_id && @call.call_type_id_unspecified?
    @call.name = name if name && @call.name.blank?
    @call.start_at ||= start_at
    @call.end_at ||= end_at
    @call.entry_deadline ||= entry_deadline
    @call.description = description || '' if @call.description.blank?
    @call.eligibility ||= eligibility
    @call.entry_fee ||= entry_fee_in_cents

    @call.save!
  rescue => e
    Rails.logger.debug e.message
    false
  end

  def description
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
