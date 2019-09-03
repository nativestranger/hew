FactoryBot.define do
  factory :address do
    city { 'Ciudad de México' }
    state { 'Ciudad de México' }
    country { 'MX' }
    street_address { Faker::Address.street_address }
    postal_code { Faker::Address.zip_code }
  end
end
