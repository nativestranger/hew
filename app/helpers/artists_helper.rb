# frozen_string_literal: true

module ArtistsHelper
  def current_artist_profile_section
    case params[:artist_profile_section]
    when 'Artist Statement'
      'Artist Statement'
    when 'Bio'
      'Bio'
    else
      'Work'
    end
  end
end
