FactoryBot.define do
  factory :show do
    name { "MyString" }
    venue { nil }
    start_at { "2019-08-21 22:40:50" }
    end_at { "2019-08-21 22:40:50" }
    overview { "MyString" }
    full_desrcription { "MyText" }
    application_deadline { "2019-08-21 22:40:50" }
    application_details { "MyText" }
  end
end
