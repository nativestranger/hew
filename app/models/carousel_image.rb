class CarouselImage < ApplicationRecord
  belongs_to :carousel
  has_one_attached :img_upload
  validates :position, uniqueness: { scope: :carousel_id }
  acts_as_list scope: :carousel
end
