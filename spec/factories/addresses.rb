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

FactoryBot.define do
  factory :address do
    city { 'Mexico City' }
    state { 'Mexico City' }
    country { 'MX' }
    street_address { Faker::Address.street_address }
    postal_code { Faker::Address.zip_code }
  end
end
