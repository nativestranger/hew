class ZappSpider < Spider
  @name = "zapp_spider"
  @engine = :selenium_chrome

  private

  def update_maybe
    # binding.pry
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
      "//*[text() = 'EVENT INFORMATION']/following-sibling::div"
    )[0].text
  rescue => e
    nil
  end

  def entry_deadline
    deadline_str = browser.text.split("Application Deadline:")[1].split(/[a-z]/i).first.strip
    Date.strptime(deadline_str, "%m/%d/%y")
  rescue => e
    nil
  end

  def call_type_id
    text = [name&.downcase, description&.downcase].join(' ')

    if text.include?('fair') || text.include?('festival')
      'fair_or_festival'
    end
  rescue => e
    nil
  end

  def name
    browser.all(
      :xpath,
      "//main//div[@class='container']//div[@class='text-center']//div[@class='font-weight-bold']"
    ).first.text
  rescue => e
    nil
  end

  def entry_fee_in_cents
    nil
  end

  def eligibility
    # TODO
  end

  def event_dates # TODO: use same as cafe?
    result = browser.text.split('Event Dates:')[1].
      split(/[a-z]/i).first.strip.split(/(?:-|to|–)/).map(&:strip)

    result
  rescue => e
    Rails.logger.debug("EVENT DATES ERROR: #{browser.current_url}")
    # TODO: allow nil for dates if no text includes 'dates'?
    nil
  end

  def start_at
    if event_dates.first.scan(/[0-9]+/).size == 1 # January 31- Feb 22, 2020
      start_at_str = event_dates.first
      raise "uncertain numeric" unless event_dates.first.scan(/[0-9]+/).first.length == 2
      start_at_str = "#{start_at_str} #{end_at.year}"
      Date.strptime(start_at_str, "%B %d %y")
    else
      Date.strptime(event_dates.first, "%m/%d/%y")
    end
  rescue => e
    Rails.logger.debug("DATES start_at ERROR: #{browser.current_url}")
    # binding.pry if !no_dates
    nil
  end

  def end_at
    if event_dates.last.scan(/[0-9]+/).size == 2 # February 29, 2020
      Date.strptime(event_dates.last, "%B %d, %y")
    else
      Date.strptime(event_dates.last, "%m/%d/%y")
    end
  rescue => e
    Rails.logger.debug("DATES end_at ERROR: #{browser.current_url}")
    # binding.pry if !no_dates
    nil
  end
end
