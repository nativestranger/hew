class ShowApplication < ApplicationRecord
  belongs_to :show
  belongs_to :user

  accepts_nested_attributes_for :user

  has_one :chat, class_name: 'Chat', as: :chatworthy, dependent: :destroy

  enum status_id: {
    fresh:    0,
    accepted: 1,
    maybe:    2,
    rejected: 3
  }

  # what validations?
end
