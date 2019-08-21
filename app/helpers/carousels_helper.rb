# frozen_string_literal: true

module CarouselsHelper
  def carousel_image_hashes(carousel)
    carousel.carousel_images.map do |carousel_image|
      CarouselImageSerializer.new(carousel_image).serializable_hash
    end
  end
end
