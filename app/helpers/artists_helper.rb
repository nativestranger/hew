# frozen_string_literal: true

module ArtistsHelper
  ARTIST_STATEMENT = 'Artist Statement'
  BIO = 'Bio'
  WORK = 'Work'

  def current_artist_profile_section_name
    case params[:artist_profile_section]
    when ARTIST_STATEMENT
      ARTIST_STATEMENT
    when BIO
      BIO
    else
      WORK
    end
  end

  def edit_supported_artist_profile_section?(section_name: nil)
    section_name ||= current_artist_profile_section_name

    section_name.in?(
      [ARTIST_STATEMENT, BIO]
    )
  end
end
