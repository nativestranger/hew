class ArtistsController < ApplicationController
  before_action :set_user
  before_action :ensure_is_artist!

  def profile
  end

  private

  def ensure_is_artist!
    redirect_to root_path unless @user.is_artist?
  end

  def set_user
    @user = User.find(params[:user_id])
  end
end
