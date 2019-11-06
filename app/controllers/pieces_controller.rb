class PiecesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_piece, only: %i[show edit update]
  before_action :authorize_user!, except: %i[new create index]

  def new
    @piece = Piece.new
  end

  def create
    @piece = Piece.new(permitted_params.merge(user: current_user))

    if @piece.save
      redirect_to edit_piece_path(@piece), notice: 'Success! You can now add your images.'
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    # TODO: transaction
    if @piece.update(permitted_params)
      update_image_order
      redirect_to @piece, notice: t('success')
    else
      render :edit
    end
  end

  def index
    @pieces = current_user.pieces
  end

  private

  def permitted_params
    params.require(:piece).permit(
      :title,
      :medium,
      :description,
      :image_ids_in_position_order,
      piece_images_attributes: %i[id name description alt _destroy]
    )
  end

  def set_piece
    @piece = Piece.find(params[:id])
  end

  def update_image_order
    image_count = @piece.piece_images.count
    @piece.piece_images.each { |gi| gi.update(position: gi.position + image_count) }
    @piece.image_ids_in_position_order.split(',').each_with_index do |gi_index, i|
      @piece.piece_images.where(id: gi_index).update(position: i + 1)
    end
  end

  def authorize_user!
    redirect_to root_path unless current_user.id == @piece.user_id
  end
end
