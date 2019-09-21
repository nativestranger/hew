# == Schema Information
#
# Table name: chat_users
#
#  id         :bigint           not null, primary key
#  seen_at    :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  chat_id    :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_chat_users_on_chat_id              (chat_id)
#  index_chat_users_on_chat_id_and_user_id  (chat_id,user_id) UNIQUE
#  index_chat_users_on_user_id              (user_id)
#

class ChatUser < ApplicationRecord
  belongs_to :chat
  belongs_to :user
  has_many :messages, dependent: :destroy
end
