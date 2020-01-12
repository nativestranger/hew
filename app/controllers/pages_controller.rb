# frozen_string_literal: true

class PagesController < ApplicationController
  before_action :authenticate_user!, except: %i[home application_submitted]

  def home
    @app_layout_container_class_additions = 'p-0'
  end

  def dashboard
    if params[:as_artist]
      @call_applications = current_user.call_applications.send(helpers.artist_dashboard_call_applications_scope)
    else
      @calls = current_user.calls.send(helpers.curator_dashboard_calls_scope)
    end
  end

  def messages
    @chats = current_user.chats.includes(:chat_users).order(updated_at: :desc)
  end
end
