# frozen_string_literal: true

module PiecesHelper
  def piece_image_hashes(piece)
    piece.piece_images.map do |piece_image|
      PieceImageSerializer.new(piece_image).serializable_hash
    end
  end

  def update_piece_image_order
    image_count = @piece.piece_images.count
    @piece.piece_images.each { |piece_image| piece_image.update(position: piece_image.position + image_count) }
    @piece.image_ids_in_position_order.split(',').each_with_index do |piece_image_index, i|
      @piece.piece_images.where(id: piece_image_index).update(position: i + 1)
    end
  end
end
