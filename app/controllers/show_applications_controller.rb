class ShowApplicationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_show, only: %i[new]

  def new
    @show_application = ShowApplication.new(
      show:                 @show,
      artist_website:       current_user.artist_website,
      artist_instagram_url: current_user.instagram_url
    )
  end

  def create
    @show_application = ShowApplication.new(permitted_params.merge(user: current_user))

    if @show_application.save
      ShowApplicationMailer.new_application(@show_application).deliver_now
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
      :supplemental_material_url
    )
  end

  def set_show
    @show = Show.find(params[:show_id])
  end
end
