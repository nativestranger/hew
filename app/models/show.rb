class Show < ApplicationRecord
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

  scope :accepting_applications, -> {
    where('application_deadline > ?', Time.current)
  }

  def submissions
    Array.new(rand(0..30))
  end

  private

  def end_at_is_after_start_at
    return unless end_at && start_at && end_at < start_at

    errors.add(:base, 'The end date must be after the start date')
  end
end
