class ShowApplicationsController < ApplicationController
  before_action :set_show, only: %i[new]

  def new
    @show_application = ShowApplication.new(
      show:                 @show,
      artist_website:       current_user&.artist_website,
      artist_instagram_url: current_user&.instagram_url
    )

    @show_application.user = User.new unless current_user
  end

  def create
    create_show_application!

    if @show_application.persisted?
      ShowApplicationMailer.new_application(@show_application).deliver_later
      ShowApplicationMailer.new_artist(@show_application).deliver_later if current_user.nil?
      redirect_to application_submitted_path, notice: t('success')
    else
      render :new
    end
  end

  private

  def permitted_params
    params.require(:show_application).permit(
      :show_id,
      :artist_statement,
      :artist_website,
      :artist_instagram_url,
      :photos_url,
      :supplemental_material_url,
      user_attributes: %i[email first_name last_name]
    )
  end

  def set_show
    @show = Show.find(params[:show_id])
  end

  def create_show_application!
    ShowApplication.transaction do
      build_show_application
      @show_application.save!
      Chat.create!(chatworthy: @show_application).setup!
    rescue ActiveRecord::RecordInvalid
      raise ActiveRecord::Rollback
    end
  end

  def build_show_application
    @show_application = ShowApplication.new(permitted_params)

    if current_user
      @show_application.user = current_user
    else
      @show_application.user.assign_attributes(
        artist_website: @show_application.artist_website,
        instagram_url:  @show_application.artist_instagram_url,
        password:       SecureRandom.uuid
      )
    end
  end
end
