# == Schema Information
#
# Table name: chats
#
#  id              :bigint           not null, primary key
#  chatworthy_type :string           default(""), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  chatworthy_id   :bigint           not null
#
# Indexes
#
#  index_chats_on_chatworthy_type_and_chatworthy_id  (chatworthy_type,chatworthy_id) UNIQUE
#

class Chat < ApplicationRecord
  belongs_to :chatworthy, polymorphic: true
  has_many :chat_users, dependent: :destroy
  has_many :users, through: :chat_users
  has_many :messages, through: :chat_users

  def setup!
    case chatworthy_type
    when "Connection"
      chatworthy.chat.chat_users.create!(user: chatworthy.user1)
      chatworthy.chat.chat_users.create!(user: chatworthy.user2)
    end
  end

  def unread_messages(user)
    seen_at = chat_users.find_by!(user: user).seen_at
    return messages unless seen_at

    messages.where("messages.created_at > ?", seen_at)
  end
end
