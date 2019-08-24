FactoryBot.define do
  factory :venue do
    name { Faker::Name.name }
    association :user
    association :address
  end
end
