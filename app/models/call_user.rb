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

class CallUser < ApplicationRecord
  belongs_to :call
  belongs_to :user

  validates :user_id, uniqueness: { scope: :call_id, message: "already exists" }

  enum role: { admin: 1, juror: 2, director: 3 }, _prefix: true
  validates :role, presence: true

  accepts_nested_attributes_for :user
end
