# == Schema Information
#
# Table name: pieces
#
#  id          :bigint           not null, primary key
#  description :string           default(""), not null
#  name        :string           default(""), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_pieces_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class PieceSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :description,
             :piece_images

  def piece_images
    object.piece_images.map do |piece_image|
      PieceImageSerializer.new(piece_image).serializable_hash
    end
  end
end
