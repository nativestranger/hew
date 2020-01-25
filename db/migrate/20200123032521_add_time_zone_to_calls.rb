class AddTimeZoneToCalls < ActiveRecord::Migration[5.2]
  def change
    add_column :calls, :time_zone, :string, default: 'UTC', null: false
    add_column :users, :time_zone, :string, default: 'UTC', null: false
  end
end
