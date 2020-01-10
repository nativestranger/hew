# == Schema Information
#
# Table name: call_category_users
#
#  id               :bigint           not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  call_category_id :bigint           not null
#  call_user_id     :bigint           not null
#
# Indexes
#
#  index_call_category_users_on_call_category_id                   (call_category_id)
#  index_call_category_users_on_call_category_id_and_call_user_id  (call_category_id,call_user_id) UNIQUE
#  index_call_category_users_on_call_user_id                       (call_user_id)
#
# Foreign Keys
#
#  fk_rails_...  (call_category_id => call_categories.id)
#  fk_rails_...  (call_user_id => call_users.id)
#

class CallCategoryUser < ApplicationRecord
  belongs_to :call_category
  has_one :category, through: :call_category
  belongs_to :call_user
  has_one :user, through: :call_user
  validates :call_category_id, uniqueness: { scope: :call_user_id }
end
