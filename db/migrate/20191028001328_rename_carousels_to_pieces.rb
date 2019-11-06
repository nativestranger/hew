class RenameCarouselsToPieces < ActiveRecord::Migration[5.2]
  def change
    rename_table :carousels, :pieces
    rename_table :carousel_images, :piece_images
    rename_column :piece_images, :carousel_id, :piece_id
  end
end
