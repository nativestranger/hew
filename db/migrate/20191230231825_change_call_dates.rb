class ChangeCallDates < ActiveRecord::Migration[5.2]
  def change
    change_column :calls, :start_at, :date
    change_column :calls, :end_at, :date
  end
end
