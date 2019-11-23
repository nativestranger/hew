class AddSpidersToCalls < ActiveRecord::Migration[5.2]
  def change
    add_column :calls, :spider, :integer, default: 0, null: false
  end
end
