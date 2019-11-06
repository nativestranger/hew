# == Schema Information
#
# Table name: pieces
#
#  id          :bigint           not null, primary key
#  description :string           default(""), not null
#  name        :string           default(""), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_pieces_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :piece do
    name { Faker::Name.name }
    user { create(:user) }
  end
end
