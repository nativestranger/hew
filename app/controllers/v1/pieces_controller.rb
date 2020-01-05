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
    # @piece_image = @piece.piece_images.new
    # @piece_image.img_upload.attach(params[:image])
    #
    # raise 'oops' unless @piece_image.save
    #
    # render json: {
    #   piece_image: PieceSerializer.new(@piece_image).serializable_hash
    # }
  end

  def update
    # @piece_image = @piece.piece_images.new
    # @piece_image.img_upload.attach(params[:image])
    #
    # raise 'oops' unless @piece_image.save
    #
    # render json: {
    #   piece_image: PieceSerializer.new(@piece_image).serializable_hash
    # }
  end

  def destroy
    Piece.find(params[:id]).destroy!

    render json: {}
  end

  private

  def set_piece
    @piece = Piece.find(params[:piece_id])
  end

  def authorize_user!
    raise 'NAUGHTY!' unless @piece.user_id == current_user.id
  end
end
