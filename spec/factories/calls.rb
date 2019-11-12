# == Schema Information
#
# Table name: calls
#
#  id                   :bigint           not null, primary key
#  application_deadline :datetime         not null
#  application_details  :text             default(""), not null
#  end_at               :datetime         not null
#  external             :boolean          default(FALSE), not null
#  external_url         :string           default(""), not null
#  full_description     :text             default(""), not null
#  is_approved          :boolean          default(FALSE), not null
#  is_public            :boolean          default(FALSE), not null
#  name                 :string           default(""), not null
#  overview             :string           default(""), not null
#  start_at             :datetime         not null
#  view_count           :integer          default(0), not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  call_type_id         :integer          not null
#  user_id              :bigint           not null
#  venue_id             :bigint
#
# Indexes
#
#  index_calls_on_user_id   (user_id)
#  index_calls_on_venue_id  (venue_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#  fk_rails_...  (venue_id => venues.id)
#

FactoryBot.define do
  factory :call do
    association :user
    name { Faker::Name.name }
    venue { create(:venue) }
    start_at { Time.current + rand(2..7).days }
    end_at { start_at + rand(8..10).days }
    overview { Faker::Movies::Lebowski.quote }
    external_url { external ? "https://#{ SecureRandom.uuid[0..5] }.com" : '' }
    call_type_id { [1,2,3].sample }
    full_description { Faker::Lorem.paragraphs(rand(1..3)).join(' ') }
    application_deadline { start_at - rand(1..7.days) }
    application_details { Faker::Lorem.paragraphs(rand(1..3)).join(' ') }
  end

  trait :current do
    application_deadline { rand(2..4).days.ago }
    start_at { application_deadline + 1.day }
    end_at { Time.current + rand(2..4).days }
  end

  trait :old do
    application_deadline { 15.days.ago }
    start_at { rand(7..14).days.ago }
    end_at { start_at + rand(1..4).days }
  end

  trait :upcoming do
    application_deadline { rand(1..4).days.ago }
    start_at { Time.current + rand(1..2).days }
    end_at { start_at + rand(1.7).days }
  end

  trait :accepting_applications do
    application_deadline { Time.current + rand(1..2).days }
    start_at { application_deadline + rand(1..2).days }
    end_at { start_at + rand(3..4).days }
  end
end
