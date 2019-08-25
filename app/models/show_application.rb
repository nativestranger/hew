class ShowApplication < ApplicationRecord
  belongs_to :show
  belongs_to :user

  enum status_id: {
    fresh:    0,
    accepted: 1,
    maybe:    2,
    rejected: 3
  }

  # validates :artist_website, presence: true
  # validates :photos_url, presence: true
end
