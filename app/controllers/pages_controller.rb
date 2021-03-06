# frozen_string_literal: true

class PagesController < ApplicationController
  before_action :authenticate_user!, except: %i[home application_submitted]

  def home
    @app_layout_container_class_additions = 'p-0'
  end

  def messages
    @chats = current_user.chats.includes(:chat_users).order(updated_at: :desc)
  end
end
