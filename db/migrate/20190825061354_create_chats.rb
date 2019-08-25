class CreateChats < ActiveRecord::Migration[5.2]
  def change
    create_table :chats do |t|
      t.string   :chatworthy_type, null: false, default: ''
      t.bigint  :chatworthy_id,   null: false
      t.timestamps
    end
    add_index :chats, [:chatworthy_type, :chatworthy_id], unique: true

    create_table :chat_users do |t|
      t.references :chat, null: false
      t.references :user, null: false
      t.timestamps
    end
    add_index :chat_users, [:chat_id, :user_id], unique: true

    create_table :messages do |t|
      t.references :chat_user, null: false
      t.text :body, null: false, default: ''
      t.timestamps
    end
  end
end
