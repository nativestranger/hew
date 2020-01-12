FactoryBot.define do
  factory :category do
    name { Faker::Name.unique.name }
  end
end
