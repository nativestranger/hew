# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email         { "#{SecureRandom.uuid[0..5]}@example.com" }
    password      { SecureRandom.uuid[0..5] }
    confirmed_at  { Time.current }
  end
end
