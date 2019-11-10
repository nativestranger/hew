# == Schema Information
#
# Table name: pieces
#
#  id          :bigint           not null, primary key
#  description :string           default(""), not null
#  medium      :string           default(""), not null
#  title       :string           default(""), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_pieces_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class Piece < ApplicationRecord
  belongs_to :user
  has_many :piece_images, -> { order('position ASC') }, dependent: :destroy
  accepts_nested_attributes_for :piece_images, allow_destroy: true

  validates :title, presence: true

  scope :with_images, -> { joins(:piece_images).includes(:piece_images) }

  attr_accessor :image_ids_in_position_order
end
