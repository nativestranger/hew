class CarouselsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_carousel, only: %i[show edit update]

  def new
    @carousel = Carousel.new
  end

  def create
    @carousel = Carousel.new(permitted_params.merge(user: current_user))

    if @carousel.save
      redirect_to @carousel, notice: t('success')
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @carousel.update(permitted_params)
      gi_count = @carousel.carousel_images.count
      @carousel.carousel_images.each { |gi| gi.update(position: gi.position + gi_count) }
      @carousel.image_ids_in_position_order.split(',').each_with_index do |gi_index, i|
        @carousel.carousel_images.where(id: gi_index).update(position: i + 1)
      end

      redirect_to @carousel, notice: t('success')
    else
      render :edit
    end
  end

  def index
    @carousels = current_user.carousels
  end

  private

  def permitted_params
    params.require(:carousel).permit(
      :name,
      :image_ids_in_position_order,
      carousel_images_attributes: %i[id name description alt _destroy]
    )
  end

  def set_carousel
    @carousel = Carousel.find(params[:id])
  end
end
