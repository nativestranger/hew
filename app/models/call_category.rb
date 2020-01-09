# == Schema Information
#
# Table name: call_categories
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  call_id     :bigint           not null
#  category_id :bigint           not null
#
# Indexes
#
#  index_call_categories_on_call_id                  (call_id)
#  index_call_categories_on_call_id_and_category_id  (call_id,category_id) UNIQUE
#  index_call_categories_on_category_id              (category_id)
#
# Foreign Keys
#
#  fk_rails_...  (call_id => calls.id)
#  fk_rails_...  (category_id => categories.id)
#

class CallCategory < ApplicationRecord
  belongs_to :call
  belongs_to :category
end
