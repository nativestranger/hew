# frozen_string_literal: true

class SettingsController < ApplicationController
  before_action :authenticate_user!

  def profile; end

  def update_profile
    if current_user.update(profile_params)
      set_locale
      redirect_to root_path, notice: success_notice
    else
      render :profile
    end
  end

  private

  def profile_params
    params.require(:user).permit(:first_name, :last_name, :locale, :email)
  end

  def success_notice
    result = t('success')
    if current_user.unconfirmed_email.present?
      result += " You must confirm your new email address."
    end
    result
  end
end
