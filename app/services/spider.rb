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

  def create_call # bulk spiders only
    if @call.new_record?
      @call.assign_attributes(
        external: true,
        is_public: true,
        call_type_id: :unspecified
      )
    end

    @call.transaction do
      @call.update!(
        user: User.system,
        spider: spider_name
      )
      ensure_admins!
      @call.scrape

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
end
