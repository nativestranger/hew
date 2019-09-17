# == Schema Information
#
# Table name: show_applications
#
#  id                        :bigint           not null, primary key
#  artist_instagram_url      :string           default(""), not null
#  artist_statement          :text             default(""), not null
#  artist_website            :string           default(""), not null
#  photos_url                :string           default(""), not null
#  supplemental_material_url :string           default(""), not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  show_id                   :bigint           not null
#  status_id                 :integer          default("fresh"), not null
#  user_id                   :bigint           not null
#
# Indexes
#
#  index_show_applications_on_show_id              (show_id)
#  index_show_applications_on_show_id_and_user_id  (show_id,user_id) UNIQUE
#  index_show_applications_on_user_id              (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (show_id => shows.id)
#  fk_rails_...  (user_id => users.id)
#

require 'rails_helper'

RSpec.describe ShowApplication, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
