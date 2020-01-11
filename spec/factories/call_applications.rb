# == Schema Information
#
# Table name: call_applications
#
#  id                        :bigint           not null, primary key
#  artist_instagram_url      :string           default(""), not null
#  artist_statement          :text             default(""), not null
#  artist_website            :string           default(""), not null
#  creation_status           :integer          default("start"), not null
#  photos_url                :string           default(""), not null
#  supplemental_material_url :string           default(""), not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  call_id                   :bigint           not null
#  category_id               :bigint
#  status_id                 :integer          default("fresh"), not null
#  user_id                   :bigint           not null
#
# Indexes
#
#  index_call_applications_on_call_id              (call_id)
#  index_call_applications_on_call_id_and_user_id  (call_id,user_id) UNIQUE
#  index_call_applications_on_category_id          (category_id)
#  index_call_applications_on_user_id              (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (call_id => calls.id)
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :call_application do
    transient do
      submitted { nil }
    end

    call { create(:call) }
    user { create(:user, is_artist: true) }
    artist_statement { Faker::Movies::Lebowski.quote }
    artist_website { 'https://www.website.com/1' }
    sequence(:artist_instagram_url) { |n| "https://www.instagram.com/#{n}" }
    sequence(:photos_url) { |n| "https://www.photos_url.com/#{n}" }
    sequence(:supplemental_material_url) { |n| "https://www.supplemental_material_url.com/#{n}" }
    status_id { CallApplication.status_ids.values.sample }
    category_id { call.categories.sample if call.categories.any? }

    after(:create) do |call_application, evaluator|
      unless call_application.call.user_id == call_application.user_id
        Connection.find_or_create_between!(
          call_application.call.user.id, call_application.user.id
        )
      end
    end

    after(:build) do |call_application, evaluator|
      if evaluator.submitted
        call_application.creation_status = 'submitted'
        big_dogs = FactoryBot.create(:piece, call_application: call_application, user: call_application.user, title: 'Big Dogs')
        FactoryBot.create(:piece_image, piece: big_dogs, name: 'big_dog1', image_fixture_path: 'big_dogs/big_dog1.jpg')
      end
    end
  end
end
