class V1::PiecesController < V1Controller
  # before_action :authenticate_user!
  before_action :set_piece, only: %i[update destroy]
  # before_action :authorize_user!

  # TODO authority
  def index
    @pieces = Piece.where(call_application_id: params.fetch(:entry_id))

    render json: {
      pieces: ActiveModel::Serializer::CollectionSerializer.new(
          @pieces,
          each_serializer: PieceSerializer
      )
    }
  end

  def create
    @call_application = CallApplication.find(params.fetch(:entry_id)) # TODO: authorize
    @piece = @call_application.pieces.build(user: current_user)

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
    @call_application = @piece.call_application # TODO: authorize

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

  def destroy
    Piece.find(params[:id]).destroy!

    render json: {}
  end

  private

  def set_piece
    @piece = Piece.find(params[:id])
  end

  def authorize_user!
    raise 'NAUGHTY!' unless @piece.user_id == current_user.id
  end

  def permitted_params
    params.require(:piece).permit(
      :title,
      :medium,
      :description
    )
  end
end
