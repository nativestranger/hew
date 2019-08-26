FactoryBot.define do
  factory :show_application do
    show { create(:show) }
    user { create(:user) }
    artist_statement { Faker::Movies::Lebowski.quote }
    artist_website { 'www.website.com/1' }
    artist_instagram_url { 'www.instagram.com/1' }
    photos_url { 'www.photos_url.com/1' }
    supplemental_material_url { 'www.supplemental_material_url.com/1' }
    status_id { ShowApplication.status_ids.values.sample }

    after(:create) do |show_application|
      Chat.create!(chatworthy: show_application).setup!
    end
  end
end
