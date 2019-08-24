# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    params[:show_sort_by] ||= 'Application Deadline'
    set_shows
    @city = City.mexico_city
  end

  private

    def set_shows
      case params[:show_sort_by]
      when 'Application Deadline'
        @shows = Show.accepting_applications.order(application_deadline: :desc)
      when 'Recently Created'
        @shows = Show.accepting_applications.order(created_at: :desc)
      end
    end
end
