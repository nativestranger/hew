class AddCategoryIdToEntries < ActiveRecord::Migration[5.2]
  def change
    add_column :call_applications, :category_id, :bigint
    add_index :call_applications, :category_id
    add_foreign_key 'call_applications', 'categories'
  end
end
