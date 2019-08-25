# t.bigint "show_id"
# t.bigint "user_id"
# t.text "artist_statement", default: "", null: false
# t.string "artist_website", default: "", null: false
# t.string "artist_instagram_url", default: "", null: false
# t.string "photos_url", default: "", null: false
# t.string "supplemental_material_url", default: "", null: false
# t.integer "status_id", default: 0, null: false

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
  end
end
