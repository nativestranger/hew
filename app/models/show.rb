class Show < ApplicationRecord
  belongs_to :user
  belongs_to :venue

  accepts_nested_attributes_for :venue

  validates :name, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true
  validates :overview, presence: true
  validates :full_description, presence: true
  validates :application_deadline, presence: true
  validates :application_details, presence: true

  validate :end_at_is_after_start_at
  validate :application_deadline_is_before_start_at

  has_many :applications, class_name: 'ShowApplication', dependent: :destroy

  scope :accepting_applications, lambda {
    where('application_deadline > ?', Time.current).published
  }

  scope :current, lambda {
    where('start_at <= ?', Time.current)
      .where('end_at >= ?', Time.current)
  }

  scope :past, -> { where('end_at <= ?', Time.current) }

  scope :unpublished, -> { where(is_public: false) }

  scope :published, -> { where(is_public: true) }

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
end
