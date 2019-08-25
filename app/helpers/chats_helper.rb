module ChatsHelper
  def last_message_preview(chat)
    last_message = chat.messages.last
    return unless last_message

    sender_copy = last_message.user.id == current_user.id ? 'You' : last_message.user.full_name

    # "#{sender_copy}: #{last_message.body.truncate(length: 20)}"
    "#{sender_copy}: #{last_message.body}"
  end

  def other_chat_users(chat)
    chat.users.where.not(id: current_user)
  end
end
