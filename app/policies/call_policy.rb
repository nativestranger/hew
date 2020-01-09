class CallPolicy
  attr_reader :user, :call

  def initialize(user, call)
    @user = user
    @call = call
  end

  def show?
    user.id == call.user_id ||
      call.call_users.role_juror.where(user_id: user.id).exists?
  end

  def update?
    user.id == call.user_id ||
      call.call_users.role_admin.where(user_id: user.id).exists?
  end
end
