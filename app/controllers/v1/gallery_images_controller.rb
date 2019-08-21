class V1::GalleryImagesController < V1Controller
  before_action :authenticate_user!
  before_action :set_gallery

  def create
    @gallery_image = @gallery.gallery_images.new
    @gallery_image.img_upload.attach(params[:image])
    if @gallery_image.save
      render json: {
        gallery_image: GalleryImageSerializer.new(@gallery_image).serializable_hash
      }
    else
      raise 'oops'
    end
  end

  private

    def set_gallery
      @gallery = Gallery.find(params[:gallery_id])
    end
end
