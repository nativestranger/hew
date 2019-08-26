class CreateShows < ActiveRecord::Migration[5.2]
  def change
    create_table :shows do |t|
      t.string :name, null: false, default: ''
      t.references :venue, foreign_key: true, null: false
      t.datetime :start_at, null: false
      t.datetime :end_at, null: false
      t.string :overview, null: false, default: ''
      t.text :full_description, null: false, default: ''
      t.datetime :application_deadline, null: false
      t.text :application_details, null: false, default: ''

      t.timestamps
    end
  end
end
