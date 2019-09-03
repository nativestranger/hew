module ShowsHelper
  def curator_dashboard_shows_scope
    if params[:past]
      :past
    elsif params[:unpublished]
      :unpublished
    elsif params[:current]
      :current
    elsif params[:upcoming]
      :upcoming
    else
      :accepting_applications
    end
  end
end
