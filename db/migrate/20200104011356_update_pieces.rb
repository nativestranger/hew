class UpdatePieces < ActiveRecord::Migration[5.2]
  def change
    add_column :pieces, :call_application_id, :bigint
    add_index :pieces, :call_application_id
    add_foreign_key 'pieces', 'call_applications'
  end
end
