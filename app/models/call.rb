# == Schema Information
#
# Table name: calls
#
#  id                   :bigint           not null, primary key
#  application_deadline :datetime         not null
#  application_details  :text             default(""), not null
#  eligibility          :integer          default("unspecified"), not null
#  end_at               :date
#  entries_count        :bigint           default(0), not null
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

# TODO: disable category editing when in certain statuses (unless maybe by owner?)

class Call < ApplicationRecord
  belongs_to :user # TODO: remove?
  belongs_to :venue, optional: true

  has_many :call_users, dependent: :destroy
  has_many :users, through: :call_users

  has_many :call_categories, dependent: :destroy
  has_many :categories, through: :call_categories
  has_many :call_category_users, through: :call_categories

  attr_accessor :skip_start_and_end

  accepts_nested_attributes_for :venue

  validates :venue, presence: true, if: :require_venue?
  validates :name, presence: true

  START_END_EXCEPTION = proc { |c| (c.skip_start_and_end || c.user_id == User.system.id) && c.external? }
  validates :start_at, presence: true, unless: START_END_EXCEPTION
  validates :end_at, presence: true, unless: START_END_EXCEPTION

  validates :overview, presence: true # TODO: get rid of overview and rename to full_description to description
  validates :call_type_id, presence: true
  validates :full_description, presence: true, unless: :external
  validates :application_deadline, presence: true
  validates :application_details, presence: true, unless: :external
  validates :external_url, url: { allow_blank: false, public_suffix: true }, if: :external
  validates :entry_fee, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true

  validate :end_at_is_after_start_at
  validate :application_deadline_is_before_start_at
  validate :owned_by_admin, if: :external
  validate :future_dates, on: :create

  before_validation :remove_venue, unless: :venue_supported? # TODO better form/venue edit

  has_many :applications, class_name: 'Entry', dependent: :destroy

  enum call_type_id: { exhibition: 1, residency: 2, publication: 3, competition: 4 }, _prefix: true
  enum eligibility: { unspecified: 1, international: 2, national: 3, regional: 4, state: 5, local: 6 }, _prefix: true
  enum spider: { none: 0, call_for_entry: 1, artwork_archive: 2, art_deadline: 3 }, _prefix: true

  scope :past_deadline, -> { where('application_deadline < ?', Time.current) }
  scope :internal, -> { where(external: false) }

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

  scope :past, -> { where('end_at <= ?', Time.current).or(where(end_at: nil).merge(past_deadline)) }

  scope :published, -> { where(is_public: true) }

  scope :approved, -> { where(is_approved: true) }

  def application_for(user)
    return false unless user

    applications.find_by(user: user)
  end

  def internal?
    !external?
  end

  private

  def future_dates
    if application_deadline && application_deadline < Time.current
      errors.add(:application_deadline, "can't be in the past")
    end
  end

  def remove_venue
    self.venue = nil
  end

  def require_venue?
    internal? && venue_supported?
  end

  def venue_supported?
    ['exhibition', 'residency'].include?(call_type_id)
  end

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
      errors.add(:base, 'Only admins can create external calls')
    end
  end
end
