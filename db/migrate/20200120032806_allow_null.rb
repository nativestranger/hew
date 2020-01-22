class AllowNull < ActiveRecord::Migration[5.2]
  def change
    change_column_null :calls, :entry_deadline, true
  end
end
