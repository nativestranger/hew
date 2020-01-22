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

  def save_with_admins
    @call.transaction do
      if @call.new_record?
        @call.assign_attributes(
          user: User.system,
          external: true,
          spider: spider_name,
          call_type_id: :unspecified
        )
      end

      @call.save!
      ensure_admins!
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
