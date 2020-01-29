class Spider < Kimurai::Base
  def self.setup_call(call)
    self.const_set(:URL, call.external_url)
    @start_urls = [call.external_url]
    @call_id = call.id
  end

  def parse(response, url:, data: {})
    @call = Call.find(
      self.class.instance_variable_get('@call_id')
    )
    update_maybe
  end

  def find_or_create_call # bulk spiders only # TODO: rename
    @call.transaction do
      if @call.new_record?
        @call.call_type_id ||= :unspecified

        @call.update!(
          external: true,
          is_public: true,
          user: User.system,
          spider: spider_name
        )
      end

      ensure_admins!
      @call.scrape unless skip_scrape?

      true
    rescue => e
      nil
    end
  end

  def ensure_admins!
    User.admins.each do |admin|
      @call.call_users.find_or_create_by!(user: admin, role: :admin)
    end
  end

  def spider_name
    raise "must implement in #{self.class.name}"
  end

  def call_type_id_fallback
    call_type_id_fallback_from(name) ||
      call_type_id_fallback_from(description)
  end

  def call_type_id_fallback_from(string)
    return unless string.present?

    string = string.downcase

    if string.include?('exhibit')
      'exhibition'
    elsif string.include?('fair') || string.include?('fest')
      'fair_or_festival'
    elsif string.include?('residenc')
      'residency'
    elsif string.include?('publication') || string.include?('magazine')
      'publication'
    elsif string.include?('competition') || string.include?('contest')
      'competition'
    else
      nil
    end
  end

  def skip_scrape?
    @call.past_deadline? ||
      @call.persisted? && @call.name.present? && @call.entry_deadline.present?
  end
end
