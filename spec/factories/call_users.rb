# == Schema Information
#
# Table name: call_users
#
#  id         :bigint           not null, primary key
#  role       :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  call_id    :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_call_users_on_call_id              (call_id)
#  index_call_users_on_call_id_and_user_id  (call_id,user_id) UNIQUE
#  index_call_users_on_user_id              (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (call_id => calls.id)
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :call_user do
    association :call
    association :user
  end
end
