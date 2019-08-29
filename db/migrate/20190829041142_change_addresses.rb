class ChangeAddresses < ActiveRecord::Migration[5.2]
  def change
    add_column :addresses, :city, :string, null: false, default: ''
    add_column :addresses, :state, :string, null: false, default: ''
    add_column :addresses, :country, :string, null: false, default: ''

    Address.all.each do |a|
      city = City.find(a.city_id)
      a.update!(
        city: city.name,
        state: city.state.name,
        country: city.state.country.name,
      )
    end

    remove_foreign_key :addresses, :cities
    remove_foreign_key :cities, :states
    remove_foreign_key :states, :countries
    remove_column :addresses, :city_id

    drop_table  :cities
    drop_table  :states
    drop_table  :countries
  end
end
