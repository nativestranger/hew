class AddEntryFeeToCalls < ActiveRecord::Migration[5.2]
  def change
    add_column :calls, :entry_fee, :integer
  end
end
