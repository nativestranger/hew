# == Schema Information
#
# Table name: call_applications
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
#  index_call_applications_on_call_id              (call_id)
#  index_call_applications_on_call_id_and_user_id  (call_id,user_id) UNIQUE
#  index_call_applications_on_category_id          (category_id)
#  index_call_applications_on_user_id              (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (call_id => calls.id)
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (user_id => users.id)
#

# TODO: rename to CallEntry
class CallApplication < ApplicationRecord
  belongs_to :call
  belongs_to :user
  belongs_to :category, optional: true

  has_many :pieces, dependent: :destroy

  accepts_nested_attributes_for :user

  enum creation_status: {
    start: 0,
    add_pieces: 1,
    review: 2,
    submitted: 3,
  }, _prefix: true

  enum status_id: {
    fresh:    0,
    accepted: 1,
    maybe:    2,
    rejected: 3
  }

  scope :pending, -> { where(status_id: %i[fresh maybe]).joins(:call).merge(Call.accepting_applications) }

  scope :past, -> {
    rejected.joins(:call).
      or(accepted.joins(:call).merge(Call.past)).
      or(joins(:call).merge(Call.past_deadline).where.not(status_id: :accepted))
  }

  scope :accepted_and_active, -> { accepted.joins(:call).merge(Call.active) }

  validates :artist_website, url: { allow_blank: true, public_suffix: true }
  validates :artist_instagram_url, url: { allow_blank: true, public_suffix: true }
  validates :photos_url, url: { allow_blank: true, public_suffix: true }
  validates :supplemental_material_url, url: { allow_blank: true, public_suffix: true }

  # TODO: require no artist_statement or minimal info?
  validates :artist_statement, presence: true

  # TODO: change to if 'past x status?'
  validate :has_valid_pieces, if: :creation_status_review?

  def future_creation_status?(some_status)
    CallApplication.creation_statuses[some_status] > CallApplication.creation_statuses[creation_status]
  end

  private

  def has_valid_pieces
    return if pieces.with_images.any?

    errors.add(:base, 'You must add at least one piece to your call.')
  end
end
