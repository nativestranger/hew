class AddCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.string :name, null: false, default: '', index: true
      t.timestamps null: false
    end

    create_table :call_categories do |t|
      t.bigint :call_id, null: false, index: true
      t.bigint :category_id, null: false, index: true
      t.timestamps null: false
    end
    add_index :call_categories, %i[call_id category_id], unique: true

    add_foreign_key :call_categories, :calls, column: :call_id
    add_foreign_key :call_categories, :categories, column: :category_id
  end
end
