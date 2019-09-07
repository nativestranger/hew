# frozen_string_literal: true

class PagesController < ApplicationController
  before_action :authenticate_user!, except: %i[home application_submitted]

  def home
    params[:show_sort_by] ||= 'Application Deadline'
    set_homepage_shows
  end

  def dashboard
    if params[:as_artist]
      @show_applications = current_user.show_applications.send(helpers.artist_dashboard_show_applications_scope)
    else
      @shows = current_user.shows.send(helpers.curator_dashboard_shows_scope)
    end
  end

  def messages
    @chats = current_user.chats.includes(:chat_users).order(updated_at: :desc)
  end

  private

  def set_homepage_shows
    case params[:show_sort_by]
    when 'Application Deadline'
      @shows = Show.accepting_applications.order(application_deadline: :asc)
    when 'Recently Created'
      @shows = Show.accepting_applications.order(created_at: :asc)
    end

    @shows = @shows.approved.published
  end
end
