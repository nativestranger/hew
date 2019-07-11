class Gallery < ApplicationRecord
  belongs_to :user
  has_many :gallery_images
  accepts_nested_attributes_for :gallery_images, allow_destroy: true

  validates :name, presence: true

  attr_accessor :images_ids_in_position_order
end
