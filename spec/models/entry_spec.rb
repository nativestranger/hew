# == Schema Information
#
# Table name: entries
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
#  index_entries_on_call_id              (call_id)
#  index_entries_on_call_id_and_user_id  (call_id,user_id) UNIQUE
#  index_entries_on_category_id          (category_id)
#  index_entries_on_user_id              (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (call_id => calls.id)
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (user_id => users.id)
#

require 'rails_helper'

RSpec.describe Entry, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
