class AddCallTypeIdToCalls < ActiveRecord::Migration[5.2]
  def change
    add_column :calls, :call_type_id, :integer
    Call.update_all(call_type_id: 1)
    change_column_null :calls, :call_type_id, false
  end
end
