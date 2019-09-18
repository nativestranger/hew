# frozen_string_literal: true

module ArtistsHelper
  def current_artist_profile_section
    case params[:artist_profile_section]
    when 'Work'
      'Work'
    when 'Bio'
      'Bio'
    else
      'Artist Statement'
    end
  end
end
