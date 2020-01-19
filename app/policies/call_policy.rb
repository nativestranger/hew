class CallPolicy
  attr_reader :user, :call

  def initialize(user, call)
    @user = user
    @call = call
  end

  def show?
    call.call_users.where(user_id: user.id).exists?
  end

  def edit?
    call.call_users.where(user_id: user.id, role: %w[owner admin]).exists?
  end

  def update?
    edit?
  end

  def manage_users?
    edit?
  end

  def view_entries?
    show? # TODO conditionally show to jury based on status?
  end

  def update_entry_status?
    call.call_users.where(
      user_id: user.id,
      role: %w[owner admin director]
    ).exists?
  end
end
