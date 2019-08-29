class MessageSerializer < ActiveModel::Serializer
  include ActionView::Helpers::DateHelper

  attributes :id,
             :body,
             :user,
             :seen,
             :created_at_in_words

  def user
    UserSerializer.new(object.user).serializable_hash
  end

  def created_at_in_words
    "#{time_ago_in_words(object.created_at)} ago"
  end
end
