class ArtDeadlineSpider < Kimurai::Base
  URL = "https://artdeadline.com/".freeze

  @name = "art_deadline_spider"
  @engine = :selenium_chrome
  @start_urls = [URL]

  # Show Dates: December 12, 2019-January 4, 2020
  # On Display: December 12, 2019-January 4, 2020

  def parse(response, url:, data: {})
    apply_filters

    call_count = 0
    attempt_count = 0

    until call_count == 5 || attempt_count > 20
      call_links[attempt_count].click

      if create_maybe
        call_count += 1
      end

      attempt_count += 1
      browser.go_back
    end
  end

  private

  def call_links
    browser.all(:xpath, "//ol[@class='jobs']//li[@class='job']//dl//dd[@class='title']//strong//a")
  end

  def create_maybe
    return if User.system.calls.where(external_url: browser.current_url).exists?

    # TODO: handle ongoing. add a start_at && end_at presence exception

    persisted = User.system.calls.create(
      user: User.system,
      external: true,
      external_url: browser.current_url,
      call_type_id: call_type_id,
      name: call_name,
      start_at: nil,
      end_at: nil,
      application_deadline: application_deadline,
      overview: possible_overview || "View details to find out more...",
      eligibility: 'unspecified',
      entry_fee: entry_fee_in_cents,
      skip_start_and_end: true,
      is_public: true,
      spider: :art_deadline,
    ).persisted?

    puts "CREATED CALL #{browser.current_url}"
    persisted
  rescue => e
    Rails.logger.debug e.message
    puts e.message
    false
  end

  def possible_overview
    ps = browser.all(:xpath, "//div[@class='section_content']//p").first&.text&.split(' – ')
    ps && ps[1].strip
  end

  def application_deadline
    deadline_str = browser.text.split("Deadline:").last.split('–').first.strip
    Date.strptime(deadline_str, "%B %d, %y")
  end

  def apply_filters
    browser.all(:xpath, "//*[@class='filter']//input[@type='checkbox']").each(&:click) # remove all
    select_call_type
    browser.find(:xpath, "//*[@class='filter']//input[@type='submit']").click
  end

  def select_call_type
    case call_type_id
    when 'competition'
      browser.find(:xpath, "//*[@id='type-competitions']").click
    when 'residency'
      browser.find(:xpath, "//*[@id='type-residencies']").click
    else
      browser.find(:xpath, "//*[@id='type-call']").click
    end
  end

  def call_type_id
    ENV['call_type'] || 'competition'
  end

  def call_name
    # TODO: this is gross.. don't do this?
    browser.find(:xpath, "//h1[@class='title']").native.text.split("\n")[1]
  end

  def entry_fee_in_cents
    nil
  end
end
