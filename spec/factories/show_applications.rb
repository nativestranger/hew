FactoryBot.define do
  factory :show_application do
    show { create(:show) }
    user { create(:user) }
    artist_statement { Faker::Movies::Lebowski.quote }
    artist_website { 'www.website.com/1' }
    sequence(:artist_instagram_url) { |n| "www.instagram.com/#{n}" }
    sequence(:photos_url) { |n| "www.photos_url.com/#{n}" }
    sequence(:supplemental_material_url) { |n| "www.supplemental_material_url.com/#{n}" }
    status_id { ShowApplication.status_ids.values.sample }

    after(:create) do |show_application|
      Chat.create!(chatworthy: show_application).setup!
    end
  end
end
