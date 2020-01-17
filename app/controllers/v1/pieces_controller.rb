class V1::PiecesController < V1Controller
  before_action :authenticate_user!
  before_action :set_piece, only: %i[update destroy]
  before_action :set_entry
  before_action :authorize_user!

  # TODO: authority
  def index
    @pieces = @entry.pieces

    render json: {
      pieces: ActiveModel::Serializer::CollectionSerializer.new(
          @pieces,
          each_serializer: PieceSerializer
      )
    }
  end

  def create
    @piece = @entry.pieces.build(user: current_user)

    if @piece.update(permitted_params)
      render json: {
        piece: PieceSerializer.new(@piece).serializable_hash
      }
    else
      render json: {
        errors: @piece.errors
      }
    end
  end

  def update
    # TODO: transaction
    if @piece.update(permitted_params) && helpers.update_piece_image_order
      render json: {
        piece: PieceSerializer.new(@piece).serializable_hash
      }
    else
      render json: {
        errors: @piece.errors
      }
    end
  end

  def destroy
    @piece.destroy!

    render json: {}
  end

  private

  def set_piece
    @piece = Piece.find(params[:id])
  end

  def set_entry
    if params[:id]
      @entry = @piece.entry
    else
      @entry = Entry.find(params.fetch(:entry_id))
    end
  end

  def authorize_user!
    raise 'NAUGHTY!' unless @entry.user_id == current_user.id
  end

  def permitted_params
    params.require(:piece).permit(
      :title,
      :medium,
      :description,
      :image_ids_in_position_order
    )
  end
end
