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

class Carousel < ApplicationRecord
  belongs_to :user
  has_many :carousel_images, -> { order('position ASC') }, dependent: :destroy
  accepts_nested_attributes_for :carousel_images, allow_destroy: true

  validates :name, presence: true

  attr_accessor :image_ids_in_position_order
end
