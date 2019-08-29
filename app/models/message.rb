class Message < ApplicationRecord
  belongs_to :chat_user
  delegate :user, to: :chat_user
  delegate :chat, to: :chat_user
  delegate :chatworthy, to: :chat
  scope :recent, -> { order(id: :desc).first(10) }
  validates :body, presence: true

  def seen
    if chat.chatworthy_type == 'Connection'
      other_chat_user = chat.chat_users.find_by!(user: chatworthy.other_user(user))
      other_chat_user.seen_at && other_chat_user.seen_at > created_at
    end
  end
end
