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

class CarouselImage < ApplicationRecord
  belongs_to :carousel
  has_one_attached :img_upload
  validates :position, uniqueness: { scope: :carousel_id }
  acts_as_list scope: :carousel
  delegate :user, to: :carousel
end
