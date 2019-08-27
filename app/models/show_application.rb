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

  validates :artist_website, url: { allow_blank: true }
  validates :artist_instagram_url, url: { allow_blank: true }
  validates :photos_url, url: { allow_blank: true }
  validates :supplemental_material_url, url: { allow_blank: true }

  # what validations?
end
