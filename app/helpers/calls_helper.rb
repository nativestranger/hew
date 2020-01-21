module CallsHelper
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
      { id: call_type_ids['public_art'], name: 'Public Art', enum_name: 'public_art', selected: true },
    ]
  end

  def call_type_emojis
    {
      "exhibition" => "👀",
      "residency" => "🏠",
      "publication" => "📰",
      "competition" => "🏆",
      "public_art" => "🏛️",
      "default"   => "🌎",
    }
  end

  def call_order_options
    [
      { name: 'Deadline (soonest)', selected: true },
      { name: 'Deadline (furthest)' },
      { name: 'Newest' },
    ]
  end

  def category_options
    categories = Category.default # todo: select from past used for user
    categories += @call.categories
    categories.uniq.map { |k| [k.name, k.id] }
  end

  def call_user_category_options
    categories = @call.categories
    categories.map { |k| [k.name, k.id] }
  end

  def homepage_search_defaults
    {
      orderOptions: call_order_options,
      call_types: call_search_call_types,
      call_type_emojis: call_type_emojis,
      page: (params[:page]&.to_i || 1)
    }
  end

  def call_entry_searcher_params
    return {} unless params[:entry_searcher]

    params.require(:entry_searcher).permit(
      category_ids: [],
      status_ids: []
    )
  end

  def call_entry_searcher_wrapped
    return {} unless params[:entry_searcher]

    { entry_searcher: call_entry_searcher_params.to_h.symbolize_keys }
  end
end
