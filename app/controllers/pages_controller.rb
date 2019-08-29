# frozen_string_literal: true

class PagesController < ApplicationController
  before_action :authenticate_user!, except: [:home, :application_submitted]

  def home
    params[:show_sort_by] ||= 'Application Deadline'
    set_shows
    @city = 'Ciudad de México'
  end

  def dashboard
    @shows = current_user.shows.send(helpers.curator_dashboard_shows_scope)
  end

  def messages
    @chats = current_user.chats.includes(:chat_users).order(updated_at: :desc)
  end

  private

  def set_shows
    case params[:show_sort_by]
    when 'Application Deadline'
      @shows = Show.accepting_applications.order(application_deadline: :desc)
    when 'Recently Created'
      @shows = Show.accepting_applications.order(created_at: :desc)
    end

    @shows = @shows.approved
  end
end
