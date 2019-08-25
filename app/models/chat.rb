class Chat < ApplicationRecord
  belongs_to :chatworthy, polymorphic: true
  has_many :chat_users, dependent: :destroy
  has_many :users, through: :chat_users
  has_many :messages, through: :chat_users

  def name
    case chatworthy_type
    when "ShowApplication"
      "#{chatworthy.show.name} Application - #{chatworthy.user.full_name}"
    end
  end

  def setup!
    case chatworthy_type
    when "ShowApplication"
      return if chatworthy.user_id == chatworthy.show.user_id

      chatworthy.chat.chat_users.create!(user: chatworthy.user)
      chatworthy.chat.chat_users.create!(user: chatworthy.show.user)
    end
  end
end
