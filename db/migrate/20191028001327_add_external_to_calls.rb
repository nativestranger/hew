class AddExternalToCalls < ActiveRecord::Migration[5.2]
  def change
    add_column :calls, :external, :boolean, null: false, default: false
    add_column :calls, :external_url, :string, null: false, default: ''
    add_column :calls, :view_count, :integer, null: false, default: 0

    change_column_null :calls, :venue_id, true
  end
end
