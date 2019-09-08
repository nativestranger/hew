class Venue < ApplicationRecord
  belongs_to :user
  belongs_to :address
  has_many :shows, dependent: :restrict_with_error

  accepts_nested_attributes_for :address
  validates :name, presence: true
  validates :website, url: { allow_blank: true, public_suffix: true }

  delegate :display_address, to: :address
end
