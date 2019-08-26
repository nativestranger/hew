FactoryBot.define do
  factory :address do
    city { City.mexico_city }
    street_address { Faker::Address.street_address }
    postal_code { Faker::Address.zip_code }
  end
end
