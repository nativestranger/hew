# == Schema Information
#
# Table name: venues
#
#  id         :bigint           not null, primary key
#  name       :string           default(""), not null
#  website    :string           default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  address_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_venues_on_address_id  (address_id)
#  index_venues_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (address_id => addresses.id)
#  fk_rails_...  (user_id => users.id)
#

class Venue < ApplicationRecord
  belongs_to :user
  belongs_to :address
  has_many :calls, dependent: :restrict_with_error

  accepts_nested_attributes_for :address
  validates :name, presence: true
  validates :website, url: { allow_blank: true, public_suffix: true }

  delegate :display_address, to: :address
end
