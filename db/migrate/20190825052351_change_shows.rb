class ChangeShows < ActiveRecord::Migration[5.2]
  def change
    change_table :shows, bulk: true do |t|
      t.references :user, foreign_key: true
    end
    change_column_null :shows, :user_id, false
  end
end
