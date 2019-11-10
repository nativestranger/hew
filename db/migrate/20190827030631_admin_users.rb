class AdminUsers < ActiveRecord::Migration[5.2]
  def change
    change_table :users, bulk: true do |t|
      t.boolean :is_admin, null: false, default: false
    end
  end
end
