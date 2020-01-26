class ResartisSpider < Spider
  @name = "resartis_spider"
  @engine = :selenium_chrome

  private

  def update_maybe
    @call.call_type_id = call_type_id if call_type_id && @call.call_type_id_unspecified?
    @call.name = name if name && @call.name.blank?
    @call.start_at ||= start_at
    @call.end_at ||= end_at
    @call.entry_deadline ||= entry_deadline
    @call.description = description if description && @call.description.blank?
    @call.eligibility ||= eligibility
    @call.entry_fee ||= entry_fee_in_cents
    # @call.time_zone = time_zone if time_zone && @call.time_zone == 'UTC'

    @call.save!
  rescue => e
    Rails.logger.debug e.message
    false
  end

  def description
    browser.all(
      :xpath,
      "//*[@class='entry-content']"
    )[0].text
  rescue => e
    nil
  end

  def entry_deadline
    deadline_str = browser.text.downcase.split("application deadline")[1].split(/[a-z]/i).first.strip
    Date.strptime(deadline_str, "%Y-%m-%d")
  rescue => e
    nil
  end

  def call_type_id
    'residency' # all on zapplication
  rescue => e
    nil
  end

  def name
    browser.all(
      :xpath,
      "//*[@class='entry-title']"
    ).first.text
  rescue => e
    nil
  end

  def entry_fee_in_cents # need shared?
    # TODO: handle exceptions in euros or other... €, CAD

    # TODO not need?
    browser.text.downase.split('fee')[1].
      match(/(?:\$)\d+(\.[\d]+)?/)&.to_s&.gsub('$', '')&.to_f * 100
  rescue => e
    Rails.logger.debug "ENTRY FEE ERROR #{e.message}"
    nil
  end

  def eligibility
    # TODO
  end

  def start_at
    deadline_str = browser.text.downcase.split("residency starts")[1].split(/[a-z]/i).first.strip
    Date.strptime(deadline_str, "%Y-%m-%d")
  rescue => e
    Rails.logger.debug("DATES start_at ERROR: #{browser.current_url}")
    # binding.pry if !no_dates
    nil
  end

  def end_at
    deadline_str = browser.text.downcase.split("residency ends")[1].split(/[a-z]/i).first.strip
    Date.strptime(deadline_str, "%Y-%m-%d")
  rescue => e
    Rails.logger.debug("DATES end_at ERROR: #{browser.current_url}")
    # binding.pry if !no_dates
    nil
  end
end
