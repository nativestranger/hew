class V1::CarouselImagesController < V1Controller
  before_action :authenticate_user!
  before_action :set_carousel

  def create
    @carousel_image = @carousel.carousel_images.new
    @carousel_image.img_upload.attach(params[:image])

    raise 'oops' unless @carousel_image.save

    render json: {
      carousel_image: CarouselImageSerializer.new(@carousel_image).serializable_hash
    }
  end

  private

  def set_carousel
    @carousel = Carousel.find(params[:carousel_id])
  end
end
