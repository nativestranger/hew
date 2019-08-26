class ChatUser < ApplicationRecord
  belongs_to :chat
  belongs_to :user
  has_many :messages, dependent: :destroy
end
