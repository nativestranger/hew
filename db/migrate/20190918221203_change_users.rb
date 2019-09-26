class ChangeUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :artist_statement, :text, null: false, default: ''
    add_column :users, :bio, :text, null: false, default: ''
  end
end
