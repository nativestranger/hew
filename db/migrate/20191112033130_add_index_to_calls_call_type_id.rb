class AddIndexToCallsCallTypeId < ActiveRecord::Migration[5.2]
  def change
    add_index :calls, :call_type_id
  end
end
