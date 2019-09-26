class UpdateData < ActiveRecord::Migration[5.2]
  def change
    Address.where(city: 'Ciudad de México').update_all(city: 'Mexico City')
    Address.where(state: 'Ciudad de México').update_all(state: 'Mexico City')
  end
end
