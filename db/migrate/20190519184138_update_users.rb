# frozen_string_literal: true

class UpdateUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :locale, :string, null: false, default: 'en'
    add_column :users, :first_name, :string, null: false, default: ''
    add_column :users, :last_name, :string, null: false, default: ''
  end
end
