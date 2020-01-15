class CallUsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_call
  before_action :set_call_user, only: %i[update]
  before_action :authorize_user!

  def create
    existing_user = User.find_by(email: permitted_params[:user_attributes][:email].strip)
    @call_user = @call.call_users.build(permitted_params)

    if existing_user.nil?
      @call_user.user.password = SecureRandom.uuid
      @call_user.user.skip_confirmation_notification!
    else
      @call_user.user = existing_user
    end

    if @call_user.save
      if existing_user.nil?
        CallUserMailer.new_user(@call_user).deliver_later
      else
        CallUserMailer.invited(@call_user).deliver_later
      end

      redirect_to call_call_users_path(@call)
    else
      @call_users = @call.call_users.order(created_at: :desc).includes(:user)
      render :index
    end
  end

  def update
    if update_call_user
      redirect_to call_call_users_path(@call)
    else
      @call_users = @call.call_users.order(created_at: :desc).includes(:user)
      render :index
    end
  end

  def index
    @call_users = @call.call_users.order(created_at: :desc).includes(:user)
    @call_user = @call.call_users.build(user: User.new)
  end

  private

  def permitted_params
    params.require(:call_user).permit(
      :role,
      user_attributes: %i[email]
    )
  end

  def update_call_user
    CallUser.transaction do
      @call_user.update!(permitted_params)

      if @call_user.supports_category_restrictions?
        reset_call_category_users!
      end

      true
    rescue ActiveRecord::RecordInvalid => e
      flash.now[:error] = e.message
      raise ActiveRecord::Rollback
    end
  end

  def reset_call_category_users!
    @call_user.call_category_users.each(&:destroy!)

    params[:call_user][:category_ids].each do |category_id|
      next if category_id.blank?

      call_category = \
        @call.call_categories.find { |cc| cc.category_id.to_s == category_id }

      next unless call_category

      @call_user.call_category_users.create!(
        call_category: call_category
      )
    end
  end

  def set_call
    @call = Call.find(params[:call_id])
  end

  def set_call_user
    @call_user = @call.call_users.find(params[:id])
  end

  # TODO: handle json auth proper
  def authorize_user!
    authorize @call, :manage_users?
  end
end
