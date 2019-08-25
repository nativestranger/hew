class GravatarUrl < ActiveRecord::Migration[5.2]
  def change
    change_table :users, bulk: true do |t|
      t.string :gravatar_url, null: false, default: ''
    end
    User.all.each { |u| u.send(:set_gravatar_url) && u.save! } if Rails.env.production?
  end
end
