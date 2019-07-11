# frozen_string_literal: true

module GalleriesHelper
  def gallery_image_hashes(gallery)
    gallery.gallery_images.map do |gallery_image|
      src = \
        Rails.application.routes.url_helpers.rails_blob_url(gallery_image.img_upload)

      { id: gallery_image.id,
        src: src }
    end
  end
end
