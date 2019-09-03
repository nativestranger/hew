# frozen_string_literal: true

module DashboardHelper
  def curator_dashboard_shows_scope
    if params[:past]
      :past
    elsif params[:current]
      :current
    elsif params[:upcoming]
      :upcoming
    else
      :accepting_applications
    end
  end

  def artist_dashboard_show_applications_scope
    if params[:accepted]
      :accepted
    elsif params[:pending]
      :pending
    elsif params[:archive]
      :archive
    else
      :pending
    end
  end
end
