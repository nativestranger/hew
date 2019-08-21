class GallerySerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :description
end
