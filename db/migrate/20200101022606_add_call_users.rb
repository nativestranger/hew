class AddCallUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :call_users do |t|
      t.bigint :call_id, null: false, index: true
      t.bigint :user_id, null: false, index: true
      t.integer :role, null: false
      t.timestamps null: false
    end
    add_index :call_users, %i[call_id user_id], unique: true

    add_foreign_key :call_users, :calls, column: :call_id
    add_foreign_key :call_users, :users, column: :user_id
  end
end
