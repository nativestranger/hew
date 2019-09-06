FactoryBot.define do
  factory :show do
    association :user
    name { Faker::Name.name }
    venue { create(:venue) }
    start_at { Time.current + rand(2..7).days }
    end_at { start_at + rand(8..10).days }
    overview { Faker::Movies::Lebowski.quote }
    full_description { Faker::Lorem.paragraphs(rand(1..3)).join(' ') }
    application_deadline { start_at - rand(1..7.days) }
    application_details { Faker::Lorem.paragraphs(rand(1..3)).join(' ') }
  end

  trait :current do
    application_deadline { rand(2..4).days.ago }
    start_at { application_deadline + 1.day }
    end_at { Time.current + rand(2..4).days }
  end

  trait :old do
    application_deadline { 15.days.ago }
    start_at { rand(7..14).days.ago }
    end_at { start_at + rand(1..4).days }
  end

  trait :upcoming do
    application_deadline { rand(1..4).days.ago }
    start_at { Time.current + rand(1..2).days }
    end_at { start_at + rand(1.7).days }
  end

  trait :accepting_applications do
    application_deadline { Time.current + rand(1..2).days }
    start_at { application_deadline + rand(1..2).days }
    end_at { start_at + rand(3..4).days }
  end
end
