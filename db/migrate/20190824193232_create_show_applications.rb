class CreateShowApplications < ActiveRecord::Migration[5.2]
  def change
    change_table :users, bulk: true do |t|
      t.string :instagram_url, null: false, default: ''
    end

    create_table :show_applications do |t|
      t.references :show, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.text :artist_statement, null: false, default: ''
      t.string :artist_website, null: false, default: ''
      t.string :artist_instagram_url, null: false, default: ''
      t.string :photos_url, null: false, default: ''
      t.string :supplemental_material_url, null: false, default: ''
      t.integer :status_id, null: false, default: 0

      t.timestamps
    end
    add_index :show_applications, %i[show_id user_id], unique: true
  end
end
