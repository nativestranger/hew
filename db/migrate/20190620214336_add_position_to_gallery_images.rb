class AddPositionToGalleryImages < ActiveRecord::Migration[5.2]
  def change
    # rubocop:disable Rails/NotNullColumn
    add_column :gallery_images, :position, :integer, null: false
    # rubocop:enable Rails/NotNullColumn
    add_index :gallery_images, %i[gallery_id position], unique: true
  end
end
