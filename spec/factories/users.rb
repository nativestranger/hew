# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { "#{SecureRandom.uuid[0..5]}@example.com" }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    artist_website { "https://#{ SecureRandom.uuid[0..5] }.com" }
    instagram_url { "https://#{ SecureRandom.uuid[0..5] }.com" }
    password      { 'password' }
    confirmed_at  { Time.current }
  end
end
