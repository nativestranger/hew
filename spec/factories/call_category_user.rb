FactoryBot.define do
  factory :call_category_user do
    call_user { call_category&.call&.call_users&.sample || create(:call_user) }
    call_category { call_user&.call&.call_categories&.sample || create(:call_category) }
  end
end
