module MessagesHelper
  def json_messages(messages)
    messages.map do |m|
      MessageSerializer.new(m).serializable_hash
    end
  end
end
