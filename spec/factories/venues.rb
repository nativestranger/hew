# == Schema Information
#
# Table name: venues
#
#  id         :bigint           not null, primary key
#  name       :string           default(""), not null
#  website    :string           default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  address_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_venues_on_address_id  (address_id)
#  index_venues_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (address_id => addresses.id)
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :venue do
    name { Faker::Name.name }
    association :user
    association :address
  end
end
