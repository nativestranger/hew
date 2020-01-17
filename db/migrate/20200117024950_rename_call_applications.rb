class RenameCallApplications < ActiveRecord::Migration[5.2]
  def change
    rename_table :call_applications, :entries
    rename_column :pieces, :call_application_id, :entry_id
    rename_column :calls, :call_applications_count, :entries_count
  end
end
