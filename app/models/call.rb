# == Schema Information
#
# Table name: calls
#
#  id                   :bigint           not null, primary key
#  application_deadline :datetime         not null
#  application_details  :text             default(""), not null
#  end_at               :datetime         not null
#  external             :boolean          default(FALSE), not null
#  external_url         :string           default(""), not null
#  full_description     :text             default(""), not null
#  is_approved          :boolean          default(FALSE), not null
#  is_public            :boolean          default(FALSE), not null
#  name                 :string           default(""), not null
#  overview             :string           default(""), not null
#  start_at             :datetime         not null
#  view_count           :integer          default(0), not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  user_id              :bigint           not null
#  venue_id             :bigint
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

class Call < ApplicationRecord
  belongs_to :user
  belongs_to :venue, optional: :external

  accepts_nested_attributes_for :venue, reject_if: :all_blank

  validates :name, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true
  validates :overview, presence: true
  validates :full_description, presence: true, unless: :external
  validates :application_deadline, presence: true
  validates :application_details, presence: true, unless: :external
  validates :external_url, url: { allow_blank: false, public_suffix: true }, if: :external

  validate :end_at_is_after_start_at
  validate :application_deadline_is_before_start_at
  validate :owned_by_admin, if: :external

  has_many :applications, class_name: 'CallApplication', dependent: :destroy

  scope :past_deadline, -> { where('application_deadline < ?', Time.current) }

  scope :accepting_applications, lambda {
    where('application_deadline >= ?', Time.current)
  }

  scope :current, lambda {
    where('start_at <= ?', Time.current)
      .where('end_at >= ?', Time.current)
  }

  scope :upcoming, lambda {
    where('start_at >= ?', Time.current)
      .where('application_deadline <= ?', Time.current)
  }

  scope :active, -> { accepting_applications.or(current).or(upcoming) }

  scope :past, -> { where('end_at <= ?', Time.current) }

  scope :published, -> { where(is_public: true) }

  scope :approved, -> { where(is_approved: true) }

  def application_for?(user)
    return false unless user

    applications.where(user: user).exists?
  end

  private

  def end_at_is_after_start_at
    return unless end_at && start_at && end_at < start_at

    errors.add(:base, 'The end date must be after the start date')
  end

  def application_deadline_is_before_start_at
    return unless application_deadline && start_at && application_deadline > start_at

    errors.add(:base, 'The application deadline must be before the start date')
  end

  def owned_by_admin
    if external? && !user&.is_admin?
      erros.add(:base, 'Only admins can create external calls')
    end
  end
end
