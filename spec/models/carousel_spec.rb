# == Schema Information
#
# Table name: carousels
#
#  id          :bigint           not null, primary key
#  description :string           default(""), not null
#  name        :string           default(""), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_carousels_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

require 'rails_helper'

RSpec.describe Carousel, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
