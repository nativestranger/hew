class CallApplicationsController < ApplicationController
  before_action :set_call
  before_action :ensure_new_application!

  def new
    @call_application = CallApplication.new(
      call:                 @call,
      artist_website:       current_user&.artist_website,
      artist_statement:     current_user&.artist_statement,
      artist_instagram_url: current_user&.instagram_url
    )

    @call_application.user = User.new unless current_user
  end

  def create
    create_call_application!

    if @call_application.persisted?
      CallApplicationMailer.new_application(@call_application).deliver_later
      CallApplicationMailer.new_artist(@call_application).deliver_later if current_user.nil?

      notice = current_user ? t('success') : "Success! You should receive a confirmation email shortly."
      redirect_to application_submitted_path, notice: notice
    else
      if current_user.nil? && User.find_by(email: @call_application.user.email)
        flash.now[:error] = "You already have an account with us. You need to sign in before applying."
      end
      render :new
    end
  end

  private

  def permitted_params
    params.require(:call_application).permit(
      :call_id,
      :artist_statement,
      :artist_website,
      :artist_instagram_url,
      :photos_url,
      :supplemental_material_url,
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
    return unless @call.application_for?(current_user)

    redirect_to public_call_details_path(@call), notice: "You've already applied to this call."
  end
end
