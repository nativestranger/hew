class CreateConnections < ActiveRecord::Migration[5.2]
  def change
    create_table :connections do |t|
      t.bigint :user1_id, null: false, index: true
      t.bigint :user2_id, null: false, index: true
    end
    add_index :connections, %i[user1_id user2_id], unique: true

    add_foreign_key :connections, :users, column: :user1_id
    add_foreign_key :connections, :users, column: :user2_id
  end
end
