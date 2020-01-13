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
end
