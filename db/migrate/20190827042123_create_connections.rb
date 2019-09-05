class CreateConnections < ActiveRecord::Migration[5.2]
  def change
    create_table :connections do |t|
      t.bigint :user1_id, null: false, index: true
      t.bigint :user2_id, null: false, index: true
    end
    add_index :connections, %i[user1_id user2_id], unique: true

    add_foreign_key :connections, :users, column: :user1_id
    add_foreign_key :connections, :users, column: :user2_id

    Chat.all.each do |chat|
      user1 = chat.chatworthy.show.user
      user2 = chat.chatworthy.user
      connection = Connection.create!(user1: user1, user2: user2)
      chat.update!(chatworthy: connection)
    end
  end
end
