FactoryBot.define do
  factory :gallery do
    name { Faker::Name.name }
    user { create(:user) }
  end
end
