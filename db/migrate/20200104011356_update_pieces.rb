class UpdatePieces < ActiveRecord::Migration[5.2]
  def change
    add_column :pieces, :call_application_id, :bigint
    add_index :pieces, :call_application_id
    add_foreign_key 'pieces', 'call_applications'

    add_column :call_applications, :creation_status, :integer, null: false, default: 0
    change_column_null :pieces, :title, true
  end
end
