class CallApplicationsController < ApplicationController
  before_action :set_call, only: %i[new create]
  before_action :ensure_new_application!, only: %i[new create]
  before_action :set_call_application, only: %i[show update]
  before_action :authorize_user!, only: %i[show update]

  include Wicked::Wizard

  steps :start, :add_pieces, :review, :submitted

  def index
    # TODO: sorting
    @call_applications = current_user.call_applications
  end

  def new
    @call_application = CallApplication.new(
      call:                 @call,
      artist_website:       current_user&.artist_website,
      artist_statement:     current_user&.artist_statement,
      artist_instagram_url: current_user&.instagram_url
    )

    @call_application.user = User.new unless current_user
  end

  def show
    @call = @call_application.call

    case step
    when :start
    when :add_pieces
    when :review
    when :submitted
      # redirect_to application_submitted_path, notice: "Success!"
    end
  end

  def create
    create_call_application!

    if @call_application.persisted?
      CallApplicationMailer.new_application(@call_application).deliver_later # if notify?

      if current_user.nil?
        CallApplicationMailer.new_artist(@call_application).deliver_later
        bypass_sign_in(@call_application.user)
        flash.notice = "Success! We sent you an email with a link to confirm your address. In the meantime, complete the steps below to finish your entry."
      end

      redirect_to wizard_path(@call_application.creation_status, call_application_id: @call_application.id)
    else
      if current_user.nil? && User.find_by(email: @call_application.user.email)
        flash.now[:error] = "You already have an account with us. You need to sign in before applying."
      end
      render :new
    end
  end

  def update
    @call = @call_application.call

    if update_call_application!
      respond_to do |format|
        format.json do
          render json: {
            redirectPath: wizard_path(@step)
          }
        end
        format.html do
          redirect_to wizard_path(@step, call_application_id: @call_application.id)
        end
      end
    else
      respond_to do |format|
        format.json do
          render json: {
            errors: @call_application.errors
          }
        end
        format.html do
          render :show
        end
      end
    end
  end

  private

  def permitted_params
    params.require(:call_application).permit(
      :call_id,
      :category_id,
      :artist_statement,
      :artist_website,
      :artist_instagram_url,
      user_attributes: %i[email first_name last_name]
    )
  end

  def set_call
    @call = Call.find(params[:call_id])
  end

  def set_call_application
    @call_application = CallApplication.find(params[:call_application_id])
  end

  def create_call_application!
    CallApplication.transaction do
      build_call_application
      @call_application.save!
      @call_application.update!(
        creation_status: @call_application.next_creation_status
      )
      # setup_connection!
    rescue ActiveRecord::RecordInvalid
      raise ActiveRecord::Rollback
    end
  end

  def update_call_application!
    CallApplication.transaction do
      @call_application.update!(permitted_params) if permitted_params.present?

      if @call_application.future_creation_status?(@step)
        @call_application.update!(creation_status: @step)
      end

      true
    rescue ActiveRecord::RecordInvalid
      raise ActiveRecord::Rollback
    end
  end

  def build_call_application
    @call_application = CallApplication.new(permitted_params)

    if current_user
      @call_application.user = current_user
    else
      @call_application.user.assign_attributes(
        is_artist:      true,
        artist_website: @call_application.artist_website,
        instagram_url:  @call_application.artist_instagram_url
      )

      @call_application.user.skip_confirmation_notification!
    end
  end

  def setup_connection!
    return if @call.user_id == @call_application.user_id

    @connection = Connection.find_or_create_between!(
      @call.user_id, @call_application.user_id
    )
  end

  private

  def ensure_new_application!
    # TODO: redirect elsewhere .. or allow multiple entries if multiple categories?
    if @call.application_for(current_user)
      redirect_to public_call_details_path(@call), notice: "You've already applied to this call."
    end
  end

  def authorize_user!
    redirect_to root_path unless @call_application.user_id == current_user&.id
  end
end
