class PublicShowsController < ApplicationController
  before_action :set_show
  before_action :ensure_public!

  def details; end

  private

  def ensure_public!
    redirect_to root_path unless @show.is_public?
  end

  def set_show
    @show = Show.find(params[:id])
  end
end
