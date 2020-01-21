class Spider < Kimurai::Base
  def save_with_admins
    @call.transaction do
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
end
