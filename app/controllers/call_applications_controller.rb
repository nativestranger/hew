class CallApplicationsController < ApplicationController
  before_action :set_call, except: %i[show update]
  before_action :ensure_new_application!, except: %i[show update]

  include Wicked::Wizard

  steps :start, :add_pieces, :review, :submit

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
    @call_application = CallApplication.find(params[:call_application_id])
    @call = @call_application.call

    case step
    when :start
      if current_user.nil?
        flash.now.notice = "Success! You should receive a confirmation email shortly. In the meantime, complete the steps below to finish your entry."
      end
    when :add_pieces
    when :review
    when :submitted
      redirect_to application_submitted_path, notice: "Success!"
    end
  end

  def create
    create_call_application!

    if @call_application.persisted?
      CallApplicationMailer.new_application(@call_application).deliver_later
      CallApplicationMailer.new_artist(@call_application).deliver_later if current_user.nil?

      redirect_to wizard_path(@call_application.creation_status, call_application_id: @call_application.id)
    else
      if current_user.nil? && User.find_by(email: @call_application.user.email)
        flash.now[:error] = "You already have an account with us. You need to sign in before applying."
      end
      render :new
    end
  end

  def update
    @call_application = CallApplication.find(params[:call_application_id])
    @call = @call_application.call

    @call_application.creation_status = next_step # need in form?
    if @call_application.update(permitted_params)
      redirect_to wizard_path(@call_application.creation_status, call_application_id: @call_application.id)
    else
      @call_application.creation_status = step
      render :show
    end
  end

  private

  def permitted_params
    params.require(:call_application).permit(
      :call_id,
      :artist_statement,
      :artist_website,
      :artist_instagram_url,
      user_attributes: %i[email first_name last_name]
    )
  end

  def set_call
    @call = Call.find(params[:call_id])
  end

  def create_call_application!
    CallApplication.transaction do
      build_call_application
      @call_application.save!
      @call_application.update!(creation_status: :add_pieces)
      setup_connection!
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
    # TODO: redirect elsewhere?
    return unless @call.application_for(current_user)

    redirect_to public_call_details_path(@call), notice: "You've already applied to this call."
  end
end
