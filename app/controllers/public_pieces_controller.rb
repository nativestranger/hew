class PublicPiecesController < ApplicationController
  # before_action :ensure_public! # TODO: private pieces/works?

  def show
    @piece = Piece.find(params[:id])
  end
end
