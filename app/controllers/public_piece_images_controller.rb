class PublicPieceImagesController < ApplicationController
  # before_action :ensure_public! # TODO: private images?

  def show
    @piece_image = PieceImage.find(params[:id])
  end
end
