class CafeSpider < Spider
  @name = "call_for_entry_spider"
  @engine = :selenium_chrome

  private

  def update_maybe
    @call.call_type_id = call_type_id if @call.call_type_id_unspecified? && call_type_id
    @call.name = name if @call.name.blank?
    @call.start_at ||= start_at
    @call.end_at ||= end_at
    @call.entry_deadline ||= entry_deadline # TODO: make end of day in estimated timezone
    @call.description = description || '' if @call.description.blank?
    @call.eligibility ||= eligibility
    @call.entry_fee ||= entry_fee_in_cents

    @call.save!
  rescue => e
    Rails.logger.debug e.message
    puts e.message
    false
  end

  # TODO: clean this up... or set a default?
  def description
    node = browser.all(:xpath, "//p").find do |paragraph|
      paragraph.text.include?('eligible') ||
        paragraph.text.include?('open to') ||
        paragraph.text.include?('invite') ||
        paragraph.text.include?('present')
    end

    node&.text
  rescue => e
    nil
  end

  def month_names
    Date::MONTHNAMES.compact
  end

  def day_names
    Date::DAYNAMES
  end

  def event_dates
    result = browser.text.split(/(?:Event Dates:|Exhibition Dates:|Exhibition and Sale dates:|Gallery Exhibition:)/)[1].strip.split("\n").first.split(/(?:-|to|–)/).map(&:strip).first(2)

    numbers_in_end_str = result[1].scan(/[0-9]+/)

    if (month_names + day_names).any? { |month_or_day| result[1].starts_with?(month_or_day) }
      digit = numbers_in_end_str[1] || numbers_in_end_str[0]
    else
      digit = numbers_in_end_str[2] || numbers_in_end_str[1] || numbers_in_end_str[0]
    end

    result[1] = result[1].partition(digit).first(2).join('')

    result
  rescue => e
    Rails.logger.debug("EVENT DATES ERROR: #{browser.current_url}")
    # TODO: allow nil for dates if no text includes 'dates'?
    nil
  end

  def name
    browser.find(:xpath, "//*[@class='fairname']").text
  rescue => e
    Rails.logger.debug("EVENT name ERROR: #{browser.current_url}")
    nil
  end

  # TODO: https://artist.callforentry.org/festivals_unique_info.php?ID=7224
  # Exhibition Dates: Friday, February 14 – Saturday, March 7, 2020

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

  def entry_deadline
    deadline_str = browser.text.split('Entry Deadline:').last.strip.split('D').first
    Date.strptime(deadline_str, "%m/%d/%y")
  rescue => e
    Rails.logger.debug("entry_deadline ERROR: #{browser.current_url}")
    nil
  end

  def eligibility
    browser.text.split('Eligibility:')[1].strip.
      match(/^(?:International|National|Regional|Local|Unspecified)/)&.to_s&.downcase
  end

  def entry_fee_in_cents
    # TODO: handle exceptions in euros or other... €, CAD

    browser.text.split('Entry Fee')[1].
      match(/(?:\$)\d+(\.[\d]+)?/)&.to_s&.gsub('$', '')&.to_f * 100
  rescue => e
    Rails.logger.debug "ENTRY FEE ERROR #{e.message}"
    nil
  end

  def call_type
    ENV['call_type'] || "Exhibitions"
  end

  CALL_TYPE_REGEX = /\A(Public Art|Exhibitions|Residencies|Competitions)/

  def call_type_id
    type_start = browser.text.split('Call Type:')[1]

    return unless type_start.strip.match(CALL_TYPE_REGEX)

    case type_start.strip.match(CALL_TYPE_REGEX)[0]
    when "Public Art"
      'public_art'
    when "Exhibitions"
      'exhibition'
    when "Residencies"
      'residency'
    when "Competitions"
      'competition'
    end
  rescue => e
    nil
  end
end
