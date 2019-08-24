class Carousel < ApplicationRecord
  belongs_to :user
  has_many :carousel_images, dependent: :destroy
  accepts_nested_attributes_for :carousel_images, allow_destroy: true

  validates :name, presence: true

  attr_accessor :image_ids_in_position_order
end
