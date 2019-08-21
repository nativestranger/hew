class CarouselImageSerializer < ActiveModel::Serializer
  attributes :id,
             :alt,
             :src,
             :name,
             :position,
             :description

  def src
    Rails.application.routes.url_helpers.rails_blob_url(
      object.img_upload
    )
  end
end
