class Message < ApplicationRecord
  belongs_to :chat_user
  delegate :user, to: :chat_user
  delegate :chat, to: :chat_user
  delegate :chatworthy, to: :chat
  scope :recent, -> { order(id: :desc).first(10) }
  validates :body, presence: true
end
