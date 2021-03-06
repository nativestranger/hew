# == Schema Information
#
# Table name: addresses
#
#  id               :bigint           not null, primary key
#  city             :string           default(""), not null
#  country          :string           default(""), not null
#  postal_code      :string           default(""), not null
#  state            :string           default(""), not null
#  street_address   :string           default(""), not null
#  street_address_2 :string           default(""), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

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
