# == Schema Information
#
# Table name: call_applications
#
#  id                        :bigint           not null, primary key
#  artist_instagram_url      :string           default(""), not null
#  artist_statement          :text             default(""), not null
#  artist_website            :string           default(""), not null
#  creation_status           :integer          default("started"), not null
#  photos_url                :string           default(""), not null
#  supplemental_material_url :string           default(""), not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  call_id                   :bigint           not null
#  status_id                 :integer          default("fresh"), not null
#  user_id                   :bigint           not null
#
# Indexes
#
#  index_call_applications_on_call_id              (call_id)
#  index_call_applications_on_call_id_and_user_id  (call_id,user_id) UNIQUE
#  index_call_applications_on_user_id              (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (call_id => calls.id)
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :call_application do
    call { create(:call) }
    user { create(:user, is_artist: true) }
    artist_statement { Faker::Movies::Lebowski.quote }
    artist_website { 'https://www.website.com/1' }
    sequence(:artist_instagram_url) { |n| "https://www.instagram.com/#{n}" }
    sequence(:photos_url) { |n| "https://www.photos_url.com/#{n}" }
    sequence(:supplemental_material_url) { |n| "https://www.supplemental_material_url.com/#{n}" }
    status_id { CallApplication.status_ids.values.sample }

    after(:create) do |call_application|
      unless call_application.call.user_id == call_application.user_id
        Connection.find_or_create_between!(
          call_application.call.user.id, call_application.user.id
        )
      end
    end
  end
end
