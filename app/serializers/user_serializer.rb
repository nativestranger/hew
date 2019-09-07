class UserSerializer < ActiveModel::Serializer
  attributes :id,
             :full_name,
             :avatar_url
end
