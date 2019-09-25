# frozen_string_literal: true

module DashboardHelper
  def curator_dashboard_calls_scope
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

  def artist_dashboard_call_applications_scope
    if params[:accepted_and_active]
      :accepted_and_active
    elsif params[:pending]
      :pending
    elsif params[:past]
      :past
    else
      :pending
    end
  end
end
