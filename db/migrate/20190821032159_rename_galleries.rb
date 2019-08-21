class RenameGalleries < ActiveRecord::Migration[5.2]
  def change
    rename_table :galleries, :carousels
    rename_table :gallery_images, :carousel_images

    rename_column :carousel_images, :gallery_id, :carousel_id
  end
end
