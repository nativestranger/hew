# == Schema Information
#
# Table name: show_applications
#
#  id                        :bigint           not null, primary key
#  artist_instagram_url      :string           default(""), not null
#  artist_statement          :text             default(""), not null
#  artist_website            :string           default(""), not null
#  photos_url                :string           default(""), not null
#  supplemental_material_url :string           default(""), not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  show_id                   :bigint           not null
#  status_id                 :integer          default("fresh"), not null
#  user_id                   :bigint           not null
#
# Indexes
#
#  index_show_applications_on_show_id              (show_id)
#  index_show_applications_on_show_id_and_user_id  (show_id,user_id) UNIQUE
#  index_show_applications_on_user_id              (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (show_id => shows.id)
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :show_application do
    show { create(:show) }
    user { create(:user) }
    artist_statement { Faker::Lorem.paragraph(rand(10..50)) }
    sequence(:artist_website) { |n| "https://www.website.com/#{n}" }
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
