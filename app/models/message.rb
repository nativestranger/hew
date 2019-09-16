# == Schema Information
#
# Table name: messages
#
#  id           :bigint           not null, primary key
#  body         :text             default(""), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  chat_user_id :bigint           not null
#
# Indexes
#
#  index_messages_on_chat_user_id  (chat_user_id)
#

class Message < ApplicationRecord
  belongs_to :chat_user
  delegate :user, to: :chat_user
  delegate :chat, to: :chat_user
  delegate :chatworthy, to: :chat
  scope :recent, -> { order(id: :desc).first(10) }
  validates :body, presence: true
end
