# == Schema Information
#
# Table name: calls
#
#  id             :bigint           not null, primary key
#  description    :text             default(""), not null
#  eligibility    :integer          default("unspecified"), not null
#  end_at         :date
#  entries_count  :bigint           default(0), not null
#  entry_deadline :datetime
#  entry_details  :text             default(""), not null
#  entry_fee      :integer
#  external       :boolean          default(FALSE), not null
#  external_url   :string           default(""), not null
#  is_approved    :boolean          default(FALSE), not null
#  is_public      :boolean          default(FALSE), not null
#  name           :string           default(""), not null
#  spider         :integer          default("none"), not null
#  start_at       :date
#  view_count     :integer          default(0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  call_type_id   :integer          not null
#  user_id        :bigint           not null
#  venue_id       :bigint
#
# Indexes
#
#  index_calls_on_call_type_id  (call_type_id)
#  index_calls_on_user_id       (user_id)
#  index_calls_on_venue_id      (venue_id)
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
    start_at { (10..90).to_a.sample.days.from_now.to_date }
    end_at { start_at + rand(8..10).days }
    external_url { external ? "https://#{ SecureRandom.uuid[0..5] }.com" : '' }
    call_type_id { [1,2,3].sample }
    description { Faker::Lorem.paragraphs(rand(4..8)).join(' ') }
    entry_deadline { (1..9).to_a.sample.days.from_now }
    entry_details { Faker::Lorem.paragraphs(rand(2..8)).join(' ') }

    after(:create) do |call|
      create :call_user, call: call, user: call.user, role: 'owner'
    end

    trait :categories do
      category_ids { Category.default.sample(2).map(&:id) }
    end

    trait :current do
      entry_deadline { rand(2..4).days.ago }
      start_at { (entry_deadline + 1.day).to_date }
      end_at { Date.current + rand(2..4).days }
    end

    trait :old do
      entry_deadline { 15.days.ago }
      start_at { rand(7..14).days.ago.to_date }
      end_at { start_at + rand(1..4).days }
    end

    trait :upcoming do
      entry_deadline { rand(1..4).days.ago }
      start_at { Date.current + rand(1..2).days }
      end_at { start_at + rand(1.7).days }
    end

    trait :accepting_entries do
      entry_deadline { Time.current + rand(1..2).days }
      start_at { (entry_deadline + rand(1..2).days).to_date }
      end_at { start_at + rand(3..4).days }
    end
  end
end
