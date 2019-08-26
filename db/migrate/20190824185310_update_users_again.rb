class UpdateUsersAgain < ActiveRecord::Migration[5.2]
  def change
    change_table :users, bulk: true do |t|
      t.boolean :is_artist, null: false, default: false
      t.boolean :is_curator, null: false, default: false
    end
  end
end
