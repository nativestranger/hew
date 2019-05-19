# frozen_string_literal: true

class SettingsController < ApplicationController
  before_action :authenticate_user!

  def profile
  end

  def update_profile
    if current_user.update(profile_params)
      set_locale
      redirect_to root_path, notice: t('success')
    else
      render :profile
    end
  end

  private

    def profile_params
      params.require(:user).permit(:first_name, :last_name, :locale)
    end
end
