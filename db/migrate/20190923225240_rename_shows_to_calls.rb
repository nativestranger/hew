class RenameShowsToCalls < ActiveRecord::Migration[5.2]
  def change
    rename_table :shows, :calls
    rename_table :show_applications, :call_applications
    rename_column :call_applications, :show_id, :call_id
  end
end
