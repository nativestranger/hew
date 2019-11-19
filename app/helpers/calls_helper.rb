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
    call_type_icons[call.call_type_id] || "fa-globe"
  end

  def call_type_icons
    {
      "exhibition" => "fa-paint-brush",
      "residency" => "fa-home",
      "publication" => "fa-newspaper-o",
      "default"   => "fa-globe",
    }
  end
end
