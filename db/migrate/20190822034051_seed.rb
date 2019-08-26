class Seed < ActiveRecord::Migration[5.2]
  def up
    require "#{Rails.root}/db/seed_states_and_cities.rb" if Rails.env.production?
  end
end
