class EntriesController < ApplicationController
  before_action :set_call, only: %i[new create]
  before_action :ensure_new_application!, only: %i[new create]
  before_action :set_entry, only: %i[show update]
  before_action :authorize_user!, only: %i[show update]

  include Wicked::Wizard

  steps :start, :add_pieces, :review, :submitted

  def index
    # TODO: sorting
    @entries = current_user.entries
  end

  def new
    @entry = Entry.new(
      call:                 @call,
      artist_website:       current_user&.artist_website,
      artist_statement:     current_user&.artist_statement,
      artist_instagram_url: current_user&.instagram_url
    )

    @entry.user = User.new unless current_user
  end

  def show
    @call = @entry.call

    case step
    when :start
    when :add_pieces
    when :review
    when :submitted
      # redirect_to application_submitted_path, notice: "Success!"
    end
  end

  def create
    create_entry!

    if @entry.persisted?
      EntryMailer.new_application(@entry).deliver_later # if notify?

      if current_user.nil?
        EntryMailer.new_artist(@entry).deliver_later
        bypass_sign_in(@entry.user)
        flash.notice = "Success! We sent you an email with a link to confirm your address. In the meantime, complete the steps below to finish your entry."
      end

      redirect_to wizard_path(@entry.creation_status, entry_id: @entry.id)
    else
      if current_user.nil? && User.find_by(email: @entry.user.email)
        flash.now[:error] = "You already have an account with us. You need to sign in before applying."
      end
      render :new
    end
  end

  def update
    @call = @entry.call

    if update_entry!
      respond_to do |format|
        format.json do
          render json: {
            redirectPath: wizard_path(@step)
          }
        end
        format.html do
          redirect_to wizard_path(@step, entry_id: @entry.id)
        end
      end
    else
      respond_to do |format|
        format.json do
          render json: {
            errors: @entry.errors
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
    params.require(:entry).permit(
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

  def set_entry
    @entry = Entry.find(params[:entry_id])
  end

  def create_entry!
    Entry.transaction do
      build_entry
      @entry.save!
      @entry.update!(
        creation_status: @entry.next_creation_status
      )
      # setup_connection!
    rescue ActiveRecord::RecordInvalid
      raise ActiveRecord::Rollback
    end
  end

  def update_entry!
    Entry.transaction do
      @entry.update!(permitted_params) if permitted_params.present?

      if @entry.future_creation_status?(@step)
        @entry.update!(creation_status: @step)
      end

      true
    rescue ActiveRecord::RecordInvalid
      raise ActiveRecord::Rollback
    end
  end

  def build_entry
    @entry = Entry.new(permitted_params)

    if current_user
      @entry.user = current_user
    else
      @entry.user.assign_attributes(
        is_artist:      true,
        artist_website: @entry.artist_website,
        instagram_url:  @entry.artist_instagram_url
      )

      @entry.user.skip_confirmation_notification!
    end
  end

  def setup_connection!
    return if @call.user_id == @entry.user_id

    @connection = Connection.find_or_create_between!(
      @call.user_id, @entry.user_id
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
    redirect_to root_path unless @entry.user_id == current_user&.id
  end
end
