class AddCallCategoryUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :call_category_users do |t|
      t.bigint :call_category_id, null: false, index: true
      t.bigint :call_user_id, null: false, index: true
      t.timestamps null: false
    end
    add_index :call_category_users, %i[call_category_id call_user_id], unique: true

    add_foreign_key :call_category_users, :call_categories, column: :call_category_id
    add_foreign_key :call_category_users, :call_users, column: :call_user_id
  end
end
