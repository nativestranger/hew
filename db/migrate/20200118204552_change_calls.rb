class ChangeCalls < ActiveRecord::Migration[5.2]
  def change
    remove_column :calls, :overview, :string
    rename_column :calls, :full_description, :description
    rename_column :calls, :application_deadline, :entry_deadline
    rename_column :calls, :application_details, :entry_details
  end
end
