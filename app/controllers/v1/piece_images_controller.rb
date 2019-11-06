class V1::PieceImagesController < V1Controller
  before_action :authenticate_user!
  before_action :set_piece
  before_action :authorize_user!

  def create
    @piece_image = @piece.piece_images.new
    @piece_image.img_upload.attach(params[:image])

    raise 'oops' unless @piece_image.save

    render json: {
      piece_image: PieceImageSerializer.new(@piece_image).serializable_hash
    }
  end

  def destroy
    @piece.piece_images.find(params[:id]).destroy!

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
