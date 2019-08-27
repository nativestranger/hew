require "administrate/base_dashboard"

class ShowApplicationDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    show: Field::BelongsTo,
    user: Field::BelongsTo,
    id: Field::Number,
    artist_statement: Field::Text,
    artist_website: Field::String,
    artist_instagram_url: Field::String,
    photos_url: Field::String,
    supplemental_material_url: Field::String,
    status_id: Field::String.with_options(searchable: false),
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :show,
    :user,
    :status_id,
    :id,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :show,
    :user,
    :artist_statement,
    :artist_website,
    :artist_instagram_url,
    :photos_url,
    :supplemental_material_url,
    :status_id,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :show,
    :user,
    :artist_statement,
    :artist_website,
    :artist_instagram_url,
    :photos_url,
    :supplemental_material_url,
  ].freeze

  # Overwrite this method to customize how show applications are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(show_application)
  #   "ShowApplication ##{show_application.id}"
  # end
end
