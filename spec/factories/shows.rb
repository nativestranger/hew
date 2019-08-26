FactoryBot.define do
  factory :show do
    association :user
    name { Faker::Name.name }
    venue { create(:venue) }
    start_at { Time.current + rand(2..7).days }
    end_at { start_at + rand(8..10).days }
    overview { Faker::Movies::Lebowski.quote }
    full_description { Faker::Lorem.paragraphs(rand(1..3)).join(' ') }
    application_deadline { 1.day.from_now }
    application_details { Faker::Lorem.paragraphs(rand(1..3)).join(' ') }
  end

  trait :current do
    start_at { Time.current - rand(1..2).days }
    end_at { Time.current + rand(1..2).days }
    application_deadline { 4.days.ago }
  end

  trait :old do
    start_at { rand(7..14).days.ago }
    end_at { start_at + rand(1..4).days }
    application_deadline { 15.days.ago }
  end
end
