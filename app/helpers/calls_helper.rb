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

  def call_search_call_types
    call_type_ids = Call.call_type_ids

    [
      { id: call_type_ids['exhibition'], name: 'Exhibition', enum_name: 'exhibition', selected: true },
      { id: call_type_ids['residency'], name: 'Residency', enum_name: 'residency', selected: true },
      { id: call_type_ids['publication'], name: 'Publication', enum_name: 'publication', selected: true },
      { id: call_type_ids['competition'], name: 'Competition', enum_name: 'competition', selected: true },
    ]
  end

  def call_type_emojis
    {
      "exhibition" => "👀",
      "residency" => "🏠",
      "publication" => "📰",
      "competition" => "🏆",
      "default"   => "🌎",
    }
  end
end
