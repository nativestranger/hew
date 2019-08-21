# frozen_string_literal: true

module GalleriesHelper
  def gallery_image_hashes(gallery)
    gallery.gallery_images.map do |gallery_image|
      GalleryImageSerializer.new(gallery_image).serializable_hash
    end
  end
end
