# frozen_string_literal: true

class EnableHstoreExtension < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'hstore'
  end
end
