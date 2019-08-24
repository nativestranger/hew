class ShowsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_show, only: %i[show edit update]

  def new
    @venue = Venue.new(address: Address.new(city: City.mexico_city))
    @show = Show.new(venue: @venue)
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
    @shows = Show.all
  end

  private

  def permitted_params
    params.require(:show).permit(
      :name,
      :start_at,
      :end_at,
      :overview,
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
