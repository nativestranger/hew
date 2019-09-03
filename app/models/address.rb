class Address < ApplicationRecord
  validates :city, presence: true
  validates :state, presence: true
  validates :country, presence: true
  validates :street_address, presence: true
  validates :postal_code, presence: true

  def display_address
    "#{full_street_address}, #{city}, #{state} #{postal_code}, #{country}"
  end

  private

  def full_street_address
    street_address_2.blank? ? street_address.to_s : "#{street_address}, #{street_address_2}"
  end
end
