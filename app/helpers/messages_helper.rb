module MessagesHelper
  def json_messages(messages)
    latest_message = messages.first
    messages.map do |m|
      check_seen = m.id == latest_message.id
      MessageSerializer.new(m, check_seen: check_seen).serializable_hash
    end
  end
end
