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
end
