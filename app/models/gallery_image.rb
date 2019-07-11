class GalleryImage < ApplicationRecord
  belongs_to :gallery
  has_one_attached :img_upload
  validates :position, uniqueness: { scope: :gallery_id }
  acts_as_list scope: :gallery
end
