# frozen_string_literal: true

module ApplicationHelper
  def options_for_enum(klass, enum, except: [])
    enums = enum.to_s.pluralize
    enum_values = klass.send(enums)
    enum_values.map { |enum_value, _db_value|
      translated = enum_to_translated_option(klass, enums, enum_value)
      [translated, enum_value]
    }.reject { |translated, enum_value| translated.blank? || enum_value.in?(except) }
  end

  def enum_to_translated_option(klass, enum, enum_value, default = enum_value.to_s.titleize)
    return if enum_value.blank?

    enums = enum.to_s.pluralize
    key = "activerecord.attributes.#{klass.to_s.underscore.gsub('/', '_')}.#{enums}.#{enum_value}"
    I18n.t(key, default: default)
  end
end
