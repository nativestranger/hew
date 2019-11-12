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

  def fa_class_for_call(call)
    case call.call_type_id
    when "exhibition"
      "fa-paint-brush"
    when "residency"
      "fa-home"
    when "publication"
      "fa-newspaper-o"
    else
      "fa-globe"
    end
  end
end
