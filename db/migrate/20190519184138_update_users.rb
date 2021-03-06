# frozen_string_literal: true

class UpdateUsers < ActiveRecord::Migration[5.2]
  def change
    change_table :users, bulk: true do |t|
      t.string :locale, null: false, default: 'en'
      t.string :first_name, null: false, default: ''
      t.string :last_name, null: false, default: ''
    end
  end
end
