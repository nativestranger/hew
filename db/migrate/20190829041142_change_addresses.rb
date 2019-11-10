class ChangeAddresses < ActiveRecord::Migration[5.2]
  def change
    add_column :addresses, :city, :string, null: false, default: ''
    add_column :addresses, :state, :string, null: false, default: ''
    add_column :addresses, :country, :string, null: false, default: ''

    remove_foreign_key :addresses, :cities
    remove_foreign_key :cities, :states
    remove_foreign_key :states, :countries
    remove_column :addresses, :city_id

    drop_table  :cities
    drop_table  :states
    drop_table  :countries
  end
end
