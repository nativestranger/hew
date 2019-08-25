class ShowsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_show, only: %i[applications show edit update update_application_status]

  def applications
    @applications = @show.applications.send(helpers.curator_application_status_scope)
  end

  def new
    @venue = Venue.new(address: Address.new(city: City.mexico_city))
    @show = Show.new(venue: @venue, is_public: true)
  end

  def create
    @show = Show.new(permitted_params)
    @show.venue.user = current_user

    if @show.save
      redirect_to @show, notice: t('success')
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @show.update(permitted_params)
      redirect_to @show, notice: t('success')
    else
      render :edit
    end
  end

  def index
    @shows = current_user.shows
  end

  def update_application_status
    status = ShowApplication.status_ids.find { |_k, v| v == params.fetch(:status_id).to_i }.first
    @show_application = @show.applications.find(params[:show_application_id])
    @show_application.update!(status_id: status)
    flash[:notice] = "Moved #{@show_application.user.full_name} to '#{status.capitalize}'."
    redirect_to show_applications_path(@show, helpers.curator_application_status_scope => true)
  end

  private

  def permitted_params
    params.require(:show).permit(
      :name,
      :start_at,
      :end_at,
      :overview,
      :is_public,
      :full_description,
      :application_details,
      :application_deadline,
      venue_attributes: [
        :id,
        :name,
        :website,
        { address_attributes: %i[id city_id street_address street_address_2 postal_code] }
      ]
    )
  end

  def set_show
    @show = Show.find(params[:id])
  end
end
