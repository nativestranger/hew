require "administrate/base_dashboard"

class CallDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    user:                 Field::BelongsTo,
    # venue: Field::BelongsTo,
    entries:              Field::HasMany.with_options(class_name: "Entry"),
    id:                   Field::Number,
    name:                 Field::String,
    start_at:             Field::DateTime,
    end_at:               Field::DateTime,
    description:          Field::Text,
    entry_deadline:       Field::DateTime,
    entry_details:        Field::Text,
    created_at:           Field::DateTime,
    updated_at:           Field::DateTime,
    is_public:            Field::Boolean,
    is_approved:          Field::Boolean
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    id
    name
    user
    entries
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :name,
    :user,
    # :venue,
    :start_at,
    :end_at,
    :description,
    :entry_deadline,
    :entry_details,
    :is_public,
    :is_approved,
    :created_at,
    :updated_at,
    :entries
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    # :user,
    # :venue,
    # :entries,
    :name,
    :start_at,
    :end_at,
    :description,
    :entry_deadline,
    :entry_details,
    :is_public,
    :is_approved
  ].freeze

  # Overwrite this method to customize how calls are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(call)
    result = "Call #{call.id} - #{call.name}"
    result += " @ #{call.venue.name}" if call.venue
    result
  end
end
