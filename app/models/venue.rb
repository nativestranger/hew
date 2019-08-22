class Venue < ApplicationRecord
  belongs_to :user
  belongs_to :address

  delegate :country, :city, :state, :postal_code, :street_address, to: :address

  accepts_nested_attributes_for :address
  validates :name, presence: true

  def full_address
    "#{ street_address }, #{ city }, #{ state } #{ postal_code }, #{ country }"
  end
end
