class ChatsController < ApplicationController
  before_action :authenticate_user!

  def show
    @chat = Chat.find(params[:id])
    chat_user
  end

  private

  def chat_user
    @chat_user ||= ChatUser.find_by!(chat: @chat, user: current_user)
  end
end
