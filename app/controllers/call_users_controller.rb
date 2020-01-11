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
    if @call_user.update(permitted_params)
      respond_to do |format|
        format.json do
          render json: {}
        end
        format.html do
          redirect_to call_call_users_path(@call)
        end
      end
    else
      respond_to do |format|
        format.json do
          render json: { message: 'FAIL' }, status: 422
        end
        format.html do
          @call_users = @call.call_users.order(created_at: :desc).includes(:user)
          render :index
        end
      end
    end
  end

  def index
    @call_users = @call.call_users.order(created_at: :desc).includes(:user)
    @call_user = @call.call_users.build(user: User.new)
  end

  private

  def permitted_params
    result = params.require(:call_user).permit(
      :role,
      user_attributes: %i[email]
    )


    # TODO: transactions &&  move to specific action?
    CallCategoryUser.where(call_user: @call_user).delete_all
    params[:call_user][:category_ids]&.each do |category_id|
      next if category_id.blank?

      CallCategoryUser.create!(
        call_category: @call.call_categories.find_by!(category_id: category_id),
        call_user: @call_user
      )
    end

    result
  end

  def set_call
    @call = Call.find(params[:call_id])
  end

  def set_call_user
    @call_user = @call.call_users.find(params[:id])
  end

  # TODO: handle json auth proper
  def authorize_user!
    redirect_to root_path unless current_user.id == @call.user_id
  end
end
