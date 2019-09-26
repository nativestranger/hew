class PublicCarouselsController < ApplicationController
  # before_action :ensure_public! # TODO: private carousels/works?

  def show
    @carousel = Carousel.find(params[:id])
  end
end
