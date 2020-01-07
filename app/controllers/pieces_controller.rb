class PiecesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_piece, except: %i[new create index]
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
      helpers.update_piece_image_order
      redirect_to artist_profile_path(user_id: current_user.id, artist_profile_section: ArtistsHelper::WORK), notice: t('success')
    else
      render :edit
    end
  end

  def destroy
    if @piece.destroy
      redirect_to artist_profile_path(user_id: current_user.id, artist_profile_section: ArtistsHelper::WORK), notice: t('success')
    else
      redirect_to edit_piece_path(@piece), error: 'Failed to delete your piece.'
    end
  end

  def index
    @pieces = current_user.pieces.for_profile
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

  def authorize_user!
    redirect_to root_path unless current_user.id == @piece.user_id
  end
end
