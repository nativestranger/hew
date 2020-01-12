class ArtistsController < ApplicationController
  before_action :set_user

  def profile
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
