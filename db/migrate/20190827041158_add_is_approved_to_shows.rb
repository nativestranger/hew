class AddIsApprovedToShows < ActiveRecord::Migration[5.2]
  def change
    change_table :shows, bulk: true do |t|
      t.boolean :is_approved, null: false, default: false
    end
  end
end
