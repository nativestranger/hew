class RenameCarouselsToPieces < ActiveRecord::Migration[5.2]
  def change
    rename_table :carousels, :pieces
    rename_table :carousel_images, :piece_images
    rename_column :piece_images, :carousel_id, :piece_id

    rename_column :pieces, :name, :title
    add_column :pieces, :medium, :string, null: false, default: ''
  end
end
