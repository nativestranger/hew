class CreateGalleries < ActiveRecord::Migration[5.2]
  def change
    create_table :galleries do |t|
      t.string :name, null: false, default: ''
      t.references :user, foreign_key: true
      t.string :description, null: false, default: ''

      t.timestamps
    end
  end
end
