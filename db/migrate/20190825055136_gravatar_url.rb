class GravatarUrl < ActiveRecord::Migration[5.2]
  def change
    change_table :users, bulk: true do |t|
      t.string :gravatar_url, null: false, default: ''
    end
  end
end
