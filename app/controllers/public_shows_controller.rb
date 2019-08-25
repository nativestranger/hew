class PublicShowsController < ApplicationController
  # before_action :ensure_public!
  before_action :set_show, only: %i[details]

  def details; end

  private

  def set_show
    @show = Show.find(params[:id])
  end
end
