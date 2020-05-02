# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit
  skip_before_action :track_ahoy_visit # TODO: reenable per env

  protect_from_forgery prepend: true, with: :exception
  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  around_action :set_time_zone, if: :current_user

  private

  def set_locale
    I18n.locale = params[:locale] ||
                  user_pref_locale ||
                  session[:locale] ||
                  location_detected_locale ||
                  header_detected_locale ||
                  I18n.default_locale

    session[:locale] = I18n.locale
  end

  def user_pref_locale
    current_user&.locale
  end

  def location_detected_locale
    # location = request.location
    # return unless location.present? && location.country_code.present?
    # return unless I18n.available_locales.include?(location.country_code)
    # location.country_code.include?("-") ? location.country_code : location.country_code.downcase
  end

  def header_detected_locale # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/LineLength
    return unless (request.env["HTTP_ACCEPT_LANGUAGE"] || "en").scan(/^[a-z]{2}/).first.present? && I18n.available_locales.include?((request.env["HTTP_ACCEPT_LANGUAGE"] || "en").scan(/^[a-z]{2}/).first)

    (request.env["HTTP_ACCEPT_LANGUAGE"] || "en").scan(/^[a-z]{2}/).first
    # rubocop:enable Metrics/LineLength
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name time_zone])
  end

  def validate_attachment_type(file, valid_types)
    # TODO: Remove this method and all calls when active storage validations are added (expected in Rails 6)
    return false if file.blank?

    if !file.content_type.in?(valid_types)
      flash[:error] = "File could not be saved. File type must be one of #{valid_types.join(', ')}."
      false
    else
      true
    end
  end

  def referer_without_param(param_name)
    referer_uri = URI.parse(request.referer)
    referer_params = Rack::Utils.parse_nested_query(referer_uri.query).except(param_name)
    referer_uri.query = referer_params.to_query
    referer_uri.to_s
  end

  def set_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end
end
