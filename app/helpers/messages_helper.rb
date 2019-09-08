module MessagesHelper
  def json_messages(messages)
    latest_message_id = messages.first.chat.messages.last.id
    messages.map do |m|
      seen_by = m.id == latest_message_id
      MessageSerializer.new(m, seen_by: seen_by).serializable_hash
    end
  end
end
