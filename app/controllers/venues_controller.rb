class VenuesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_venue, only: %i[show edit update]
  before_action :authorize_user!, except: %i[new create]

  def new
    @venue = Venue.new
    @venue.address = Address.new(city: City.mexico_city)
  end

  def create
    @venue = Venue.new(permitted_params.merge(user: current_user))

    if @venue.save
      redirect_to @venue, notice: t('success')
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @venue.update(permitted_params)
      redirect_to @venue, notice: t('success')
    else
      render :edit
    end
  end

  def index
    @venues = current_user.venues
  end

  private

  def permitted_params
    params.require(:venue).permit(
      :name,
      :website,
      address_attributes: %i[id city_id street_address street_address_2 postal_code]
    )
  end

  def set_venue
    @venue = Venue.find(params[:id])
  end

  def authorize_user!
    redirect_to root_path unless current_user.id == @venue.user_id
  end
end
