# == Schema Information
#
# Table name: calls
#
#  id                   :bigint           not null, primary key
#  application_deadline :datetime         not null
#  application_details  :text             default(""), not null
#  end_at               :datetime         not null
#  full_description     :text             default(""), not null
#  is_approved          :boolean          default(FALSE), not null
#  is_public            :boolean          default(FALSE), not null
#  name                 :string           default(""), not null
#  overview             :string           default(""), not null
#  start_at             :datetime         not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  user_id              :bigint           not null
#  venue_id             :bigint           not null
#
# Indexes
#
#  index_calls_on_user_id   (user_id)
#  index_calls_on_venue_id  (venue_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#  fk_rails_...  (venue_id => venues.id)
#

require 'rails_helper'

RSpec.describe Call, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
