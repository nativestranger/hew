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

# TODO: prevent adding oneself. OR autocreate call_user for creator and disabled editing role.

class CallUser < ApplicationRecord
  belongs_to :call
  belongs_to :user
  has_many :call_category_users, dependent: :destroy
  has_many :call_categories, through: :call_category_users
  has_many :categories, through: :call_categories

  validates :user_id, uniqueness: { scope: :call_id, message: "this user has already been added to this call." }

  # TODO: unique index if owner
  validates :call_id, uniqueness: { scope: :role, message: "cannot have more than one owner." }, if: :role_owner?

  enum role: { owner: 0, admin: 1, juror: 2, director: 3 }, _prefix: true
  validates :role, presence: true # is judge a director? - https://artcall.org/pages/faq

  accepts_nested_attributes_for :user
end
