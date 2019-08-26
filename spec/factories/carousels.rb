FactoryBot.define do
  factory :carousel do
    name { Faker::Name.name }
    user { create(:user) }
  end
end
