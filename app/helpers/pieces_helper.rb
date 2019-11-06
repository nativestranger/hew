# frozen_string_literal: true

module PiecesHelper
  def piece_image_hashes(piece)
    piece.piece_images.map do |piece_image|
      PieceImageSerializer.new(piece_image).serializable_hash
    end
  end
end
