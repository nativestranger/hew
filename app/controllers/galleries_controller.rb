class GalleriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_gallery, only: %i[show edit update]

  def new
    @gallery = Gallery.new
  end

  def create
    @gallery = Gallery.new(permitted_params.merge(user: current_user))

    if @gallery.save
      redirect_to @gallery, notice: t('success')
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @gallery.update(permitted_params)
      gi_count = @gallery.gallery_images.count
      @gallery.gallery_images.each { |gi| gi.update(position: gi.position + gi_count) }
      @gallery.image_ids_in_position_order.split(',').each_with_index do |gi_index, i|
        @gallery.gallery_images.where(id: gi_index).update(position: i + 1)
      end

      redirect_to @gallery, notice: t('success')
    else
      render :edit
    end
  end

  def index
    @galleries = current_user.galleries
  end

  private

    def permitted_params
      params.require(:gallery).permit(
        :name,
        :image_ids_in_position_order,
        gallery_images_attributes: [:id, :name, :description, :alt, :_destroy]
      )
    end

    def set_gallery
      @gallery = Gallery.find(params[:id])
    end
end
