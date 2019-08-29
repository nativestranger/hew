FactoryBot.define do
  factory :show_application do
    show { create(:show) }
    user { create(:user) }
    artist_statement { Faker::Movies::Lebowski.quote }
    artist_website { 'https://www.website.com/1' }
    sequence(:artist_instagram_url) { |n| "https://www.instagram.com/#{n}" }
    sequence(:photos_url) { |n| "https://www.photos_url.com/#{n}" }
    sequence(:supplemental_material_url) { |n| "https://www.supplemental_material_url.com/#{n}" }
    status_id { ShowApplication.status_ids.values.sample }

    after(:create) do |show_application|
      unless show_application.show.user_id == show_application.user_id
        Connection.find_or_create_between!(
          show_application.show.user.id, show_application.user.id
        )
      end
    end
  end
end
