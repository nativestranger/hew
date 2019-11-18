class AddEligibilityToCalls < ActiveRecord::Migration[5.2]
  def change
    add_column :calls, :eligibility, :integer, default: 1
    Call.update_all(eligibility: 1)
    change_column_null :calls, :eligibility, false
  end
end
