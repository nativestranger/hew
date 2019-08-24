class CreateVenues < ActiveRecord::Migration[5.2]
  def change
    create_table :countries do |t|
      t.string :name, null: false, default: '', index: { unique: true }
      t.timestamps
    end

    create_table :states do |t|
      t.string :name, null: false, default: ''
      t.references :country, foreign_key: true, null: false
      t.timestamps
    end
    add_index :states, %i[name country_id], unique: true

    create_table :cities do |t|
      t.string :name, null: false, default: ''
      t.references :state, foreign_key: true, null: false
      t.timestamps
    end
    add_index :cities, %i[name state_id], unique: true

    create_table :addresses do |t|
      t.references :city, foreign_key: true, null: false
      t.string :street_address, null: false, default: ''
      t.string :postal_code, null: false, default: ''
      t.timestamps
    end

    create_table :venues do |t|
      t.string :name, null: false, default: ''
      t.string :website, null: false, default: ''
      t.references :address, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
