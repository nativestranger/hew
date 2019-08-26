class Chat < ApplicationRecord
  belongs_to :chatworthy, polymorphic: true
  has_many :chat_users, dependent: :destroy
  has_many :users, through: :chat_users
  has_many :messages, through: :chat_users

  def setup!
    case chatworthy_type
    when "ShowApplication"
      return if chatworthy.user_id == chatworthy.show.user_id

      chatworthy.chat.chat_users.create!(user: chatworthy.user)
      chatworthy.chat.chat_users.create!(user: chatworthy.show.user)
    end
  end

  def unread_messages(user)
    seen_at = chat_users.find_by!(user: user).seen_at
    return messages unless seen_at

    messages.where("messages.created_at > ?", seen_at)
  end
end
