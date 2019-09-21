# == Schema Information
#
# Table name: carousels
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
#  index_carousels_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class CarouselSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :description,
             :carousel_images

  def carousel_images
    object.carousel_images.map do |carousel_image|
      CarouselImageSerializer.new(carousel_image).serializable_hash
    end
  end
end
