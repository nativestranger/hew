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

  def seen
    return unless instance_options[:check_seen]

    if object.chat.chatworthy_type == 'Connection'
      other_chat_user = object.chat.chat_users.find_by!(user: object.chat.chatworthy.other_user(object.user))
      other_chat_user.seen_at && other_chat_user.seen_at > object.created_at
    end
  end
end
