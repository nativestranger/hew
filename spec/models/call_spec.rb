# == Schema Information
#
# Table name: calls
#
#  id                   :bigint           not null, primary key
#  application_deadline :datetime         not null
#  application_details  :text             default(""), not null
#  eligibility          :integer          default("unspecified"), not null
#  end_at               :date
#  entry_fee            :integer
#  external             :boolean          default(FALSE), not null
#  external_url         :string           default(""), not null
#  full_description     :text             default(""), not null
#  is_approved          :boolean          default(FALSE), not null
#  is_public            :boolean          default(FALSE), not null
#  name                 :string           default(""), not null
#  overview             :string           default(""), not null
#  spider               :integer          default("none"), not null
#  start_at             :date
#  view_count           :integer          default(0), not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  call_type_id         :integer          not null
#  user_id              :bigint           not null
#  venue_id             :bigint
#
# Indexes
#
#  index_calls_on_call_type_id  (call_type_id)
#  index_calls_on_user_id       (user_id)
#  index_calls_on_venue_id      (venue_id)
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
