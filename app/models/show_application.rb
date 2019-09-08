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
