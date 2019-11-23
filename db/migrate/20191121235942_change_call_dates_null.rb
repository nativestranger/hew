class ChangeCallDatesNull < ActiveRecord::Migration[5.2]
  def change
    change_column_null :calls, :start_at, true
    change_column_null :calls, :end_at, true
  end
end
