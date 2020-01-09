FactoryBot.define do
  factory :call_user do
    association :call
    association :user
  end
end
