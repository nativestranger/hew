# frozen_string_literal: true

class SettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_s3_direct_post, only: %i[profile update_profile]

  def profile; end

  def update_profile
    if current_user.update(profile_params)
      if validate_attachment_type(params[:user][:avatar], %w[image/png image/jpeg image/jpg])
        current_user.avatar.attach(params[:user][:avatar])
      end
      set_locale
      redirect_to root_path, notice: success_notice
    else
      render :profile
    end
  end

  private

  def profile_params
    params.require(:user).permit(
      :artist_website,
      :instagram_url,
      :first_name,
      :last_name,
      :is_curator,
      :is_artist,
      :locale,
      :email
    )
  end

  def success_notice
    result = t('success')
    result += " You must confirm your new email address." if current_user.unconfirmed_email.present?
    result
  end

  # TODO: use this
  def set_s3_direct_post
    @s3_direct_post = S3_BUCKET.presigned_post(
      key: "uploads/#{SecureRandom.uuid}/${filename}",
      success_action_status: '201',
      acl: 'public-read'
    )
  end
end
