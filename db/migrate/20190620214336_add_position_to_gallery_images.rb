class AddPositionToGalleryImages < ActiveRecord::Migration[5.2]
  def change
    add_column :gallery_images, :position, :integer, null: false
    add_index :gallery_images, %i[gallery_id position], unique: true
  end
end
