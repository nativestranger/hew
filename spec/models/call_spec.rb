# == Schema Information
#
# Table name: calls
#
#  id             :bigint           not null, primary key
#  description    :text             default(""), not null
#  eligibility    :integer          default("unspecified"), not null
#  end_at         :date
#  entries_count  :bigint           default(0), not null
#  entry_deadline :datetime
#  entry_details  :text             default(""), not null
#  entry_fee      :integer
#  external       :boolean          default(FALSE), not null
#  external_url   :string           default(""), not null
#  is_approved    :boolean          default(FALSE), not null
#  is_public      :boolean          default(FALSE), not null
#  name           :string           default(""), not null
#  spider         :integer          default("none"), not null
#  start_at       :date
#  time_zone      :string           default("UTC"), not null
#  view_count     :integer          default(0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  call_type_id   :integer          not null
#  user_id        :bigint           not null
#  venue_id       :bigint
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
