class Message < ApplicationRecord
  belongs_to :chat_user
  delegate :user, to: :chat_user
  scope :recent, -> { order(id: :desc).first(10) }
  validates :body, presence: true
end
