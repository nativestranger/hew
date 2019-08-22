class Address < ApplicationRecord
  belongs_to :city
  delegate :state, to: :city
  delegate :country, to: :state

  validates :street_address, presence: true
  validates :postal_code, presence: true
end
