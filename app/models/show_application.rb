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

class ShowApplication < ApplicationRecord
  belongs_to :show
  belongs_to :user

  accepts_nested_attributes_for :user

  enum status_id: {
    fresh:    0,
    accepted: 1,
    maybe:    2,
    rejected: 3
  }

  scope :pending, -> { where(status_id: %i[fresh maybe]).joins(:show).merge(Show.accepting_applications) }

  scope :past, -> {
    rejected.joins(:show).
      or(accepted.joins(:show).merge(Show.past)).
      or(joins(:show).merge(Show.past_deadline).where.not(status_id: :accepted))
  }

  scope :accepted_and_active, -> { accepted.joins(:show).merge(Show.active) }

  validates :artist_website, url: { allow_blank: true, public_suffix: true }
  validates :artist_instagram_url, url: { allow_blank: true, public_suffix: true }
  validates :photos_url, url: { allow_blank: true, public_suffix: true }
  validates :supplemental_material_url, url: { allow_blank: true, public_suffix: true }

  # what validations?
end
