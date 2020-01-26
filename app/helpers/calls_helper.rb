module CallsHelper
  def titleize_snakecase(str)
    str.gsub('_', ' ').titleize
  end

  def fa_class_for_call(call)
    call_type_icons[call.call_type_id] || "fa-globe"
  end

  def call_search_call_types
    call_type_ids = Call.call_type_ids

    result = [
      { id: call_type_ids['exhibition'], name: 'Exhibitions', enum_name: 'exhibition', selected: true },
      { id: call_type_ids['residency'], name: 'Residencies', enum_name: 'residency', selected: true },
      { id: call_type_ids['publication'], name: 'Publications', enum_name: 'publication', selected: true },
      { id: call_type_ids['competition'], name: 'Competitions', enum_name: 'competition', selected: true },
      { id: call_type_ids['public_art'], name: 'Public Art', enum_name: 'public_art', selected: true },
      { id: call_type_ids['fair_or_festival'], name: 'Fairs & Festivals', enum_name: 'fair_or_festival', selected: true },
    ]

    if current_user&.is_admin?
      result << { id: call_type_ids['unspecified'], name: 'Unspecified', enum_name: 'unspecified', selected: true }
    end

    result
  end

  def call_search_spiders
    spiders = Call.spiders

    [
      { id: spiders['call_for_entry'], name: 'Cafe', enum_name: 'call_for_entry', selected: true },
      { id: spiders['artwork_archive'], name: 'ArtworkArchive', enum_name: 'artwork_archive', selected: true },
      { id: spiders['art_deadline'], name: 'ArtDeadline', enum_name: 'art_deadline', selected: true },
      { id: spiders['zapplication'], name: 'Zapplication', enum_name: 'zapplication', selected: true },
    ]
  end

  def call_type_emojis
    {
      "exhibition" => "👀",
      "residency" => "🏠",
      "publication" => "📰",
      "competition" => "🏆",
      "public_art" => "🏛️",
      "fair_or_festival" => "🎪",
      "default"   => "🌎",
    }
  end

  def call_order_options
    [
      { name: 'Deadline (soonest)', selected: true },
      { name: 'Deadline (furthest)' },
      { name: 'Newest' },
      { name: 'Updated' },
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

  def calls_search_defaults
    homepage_search_defaults.merge(
      calls: [],
      spiders: call_search_spiders
    )
  end
end
