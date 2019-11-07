# == Schema Information
#
# Table name: piece_images
#
#  id          :bigint           not null, primary key
#  alt         :string           default(""), not null
#  description :string           default(""), not null
#  name        :string           default(""), not null
#  position    :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  piece_id    :bigint
#
# Indexes
#
#  index_piece_images_on_piece_id               (piece_id)
#  index_piece_images_on_piece_id_and_position  (piece_id,position) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (piece_id => pieces.id)
#

class PieceImageSerializer < ActiveModel::Serializer
  attributes :id,
             :alt,
             :src,
             :name,
             :path,
             :position,
             :description

  def src
    Rails.application.routes.url_helpers.rails_blob_url(
      object.img_upload
    )
  end

  def path
    Rails.application.routes.url_helpers.public_piece_image_path(
      object
    )
  end
end
