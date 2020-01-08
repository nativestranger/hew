# == Schema Information
#
# Table name: pieces
#
#  id                  :bigint           not null, primary key
#  description         :string           default(""), not null
#  medium              :string           default(""), not null
#  title               :string           default("")
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  call_application_id :bigint
#  user_id             :bigint           not null
#
# Indexes
#
#  index_pieces_on_call_application_id  (call_application_id)
#  index_pieces_on_user_id              (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (call_application_id => call_applications.id)
#  fk_rails_...  (user_id => users.id)
#

class PieceSerializer < ActiveModel::Serializer
  attributes :id,
             :title,
             :medium,
             :description,
             :piece_images

  def piece_images
    object.piece_images.order(position: :asc).map do |piece_image|
      PieceImageSerializer.new(piece_image).serializable_hash
    end
  end
end
