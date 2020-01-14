class AddCallApplicationCountToCalls < ActiveRecord::Migration[5.2]
  def change
    add_column :calls, :call_applications_count, :bigint, null: false, default: 0
  end
end
