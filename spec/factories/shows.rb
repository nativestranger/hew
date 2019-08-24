FactoryBot.define do
  factory :show do
    name { Faker::Name.name }
    venue { create(:venue) }
    start_at { Time.current + rand(2..7).days }
    end_at { start_at + rand(8..10).days }
    overview { Faker::Movies::Lebowski.quote }
    full_description { Faker::Lorem.paragraphs(rand(1..3)).join(' ') }
    application_deadline { 1.day.from_now }
    application_details { Faker::Lorem.paragraphs(rand(1..3)).join(' ') }
  end
end
