class CreateGalleryImages < ActiveRecord::Migration[5.2]
  def change
    create_table :gallery_images do |t|
      t.string :name, null: false, default: ''
      t.string :description, null: false, default: ''
      t.string :alt, null: false, default: ''
      t.references :gallery, foreign_key: true
      t.timestamps
    end
  end
end
