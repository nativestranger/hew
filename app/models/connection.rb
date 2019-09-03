class Connection < ApplicationRecord
  belongs_to :user1, class_name: 'User'
  belongs_to :user2, class_name: 'User'

  has_one :chat, class_name: 'Chat', as: :chatworthy, dependent: :destroy

  validate :users_are_different

  def self.find_between(user1_id, user2_id)
    find_by(
      user1_id: [user1_id, user2_id],
      user2_id: [user1_id, user2_id]
    )
  end

  def self.find_or_create_between!(user1_id, user2_id) # TODO: pg advisory lock
    existing_connection = Connection.find_between(user1_id, user2_id)
    return existing_connection if existing_connection

    connection = new(user1_id: user1_id, user2_id: user2_id)
    connection.save!
    Chat.create!(chatworthy: connection).setup!
    connection
  end

  def other_user(user)
    raise Exception, message "Connection #{id} not shared by user #{user.id}." unless user.id.in?([user1_id, user2_id])

    user.id == user1_id ? user2 : user1
  end

  private

  def users_are_different
    return unless user1_id == user2_id

    errors.add(:base, 'Cannot connect a user to itself')
  end
end
