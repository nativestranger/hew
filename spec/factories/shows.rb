FactoryBot.define do
  factory :show do
    name { Faker::Name.name }
    venue { nil }
    start_at { Time.current + 7.days }
    end_at { Time.current + 8.days }
    overview { "MyString" }
    full_desrcription { "MyText" }
    application_deadline { 1.day.from_now }
    application_details { "MyText" }
  end
end
