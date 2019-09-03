class V1::ChatsController < V1Controller
  before_action :authenticate_user!
  before_action :set_chat

  def messages
    set_messages!
    render json: { messages: helpers.json_messages(@messages) }
  end

  def create_message
    create_message!
    render json: { messages: helpers.json_messages(@messages) }
  end

  private

  def set_chat
    @chat = Chat.find(params[:id])
  end

  def set_messages!
    @messages = @chat.messages.includes(chat_user: :user).recent
    chat_user.update!(seen_at: Time.zone.now)
  end

  def message_params
    params.require(:message).permit(:body)
  end

  def chat_user
    @chat_user ||= @chat.chat_users.find_by!(user: current_user)
  end

  def create_message!
    Message.transaction do
      chat_user.messages.create!(message_params)
      @chat.touch
      set_messages!
    rescue ActiveRecord::RecordInvalid
      raise ActiveRecord::Rollback
    end
  end
end
