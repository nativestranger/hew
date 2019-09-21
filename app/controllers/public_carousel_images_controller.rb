class PublicCarouselImagesController < ApplicationController
  # before_action :ensure_public! # TODO: private images?

  def show
    @carousel_image = CarouselImage.find(params[:id])
  end
end
