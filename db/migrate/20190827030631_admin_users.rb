class AdminUsers < ActiveRecord::Migration[5.2]
  def change
    change_table :users, bulk: true do |t|
      t.boolean :is_admin, null: false, default: false
    end

    User.find_by(email: 'eric.ed.arnold@gmail.com')&.update!(is_admin: true)
  end
end
