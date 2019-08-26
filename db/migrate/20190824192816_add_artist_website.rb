class AddArtistWebsite < ActiveRecord::Migration[5.2]
  def change
    change_table :users, bulk: true do |t|
      t.string :artist_website, null: false, default: ''
    end
  end
end
