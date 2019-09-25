module CallsHelper
  def curator_application_status_scope
    if params[:accepted]
      :accepted
    elsif params[:maybe]
      :maybe
    elsif params[:rejected]
      :rejected
    else
      :fresh
    end
  end
end
