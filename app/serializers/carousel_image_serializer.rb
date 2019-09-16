# == Schema Information
#
# Table name: carousel_images
#
#  id          :bigint           not null, primary key
#  alt         :string           default(""), not null
#  description :string           default(""), not null
#  name        :string           default(""), not null
#  position    :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  carousel_id :bigint
#
# Indexes
#
#  index_carousel_images_on_carousel_id               (carousel_id)
#  index_carousel_images_on_carousel_id_and_position  (carousel_id,position) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (carousel_id => carousels.id)
#

class CarouselImageSerializer < ActiveModel::Serializer
  attributes :id,
             :alt,
             :src,
             :name,
             :position,
             :description

  def src
    Rails.application.routes.url_helpers.rails_blob_url(
      object.img_upload
    )
  end
end
