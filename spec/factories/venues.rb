FactoryBot.define do
  factory :venue do
    name { Faker::Name.name }
    association :address
  end
end
