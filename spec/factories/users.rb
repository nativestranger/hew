# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  artist_statement       :text             default(""), not null
#  artist_website         :string           default(""), not null
#  bio                    :text             default(""), not null
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  first_name             :string           default(""), not null
#  gravatar_url           :string           default(""), not null
#  instagram_url          :string           default(""), not null
#  is_admin               :boolean          default(FALSE), not null
#  is_artist              :boolean          default(FALSE), not null
#  is_curator             :boolean          default(FALSE), not null
#  last_name              :string           default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  locale                 :string           default("en"), not null
#  locked_at              :datetime
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  time_zone              :string           default("UTC"), not null
#  unconfirmed_email      :string
#  unlock_token           :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#


FactoryBot.define do
  factory :user do
    email { "#{SecureRandom.uuid[0..5]}@example.com" }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    artist_statement { Faker::Movies::Lebowski.quote }
    artist_website { "https://#{ SecureRandom.uuid[0..5] }.com" }
    instagram_url { "https://#{ SecureRandom.uuid[0..5] }.com" }
    password      { 'password' }
    confirmed_at  { Time.current }
  end
end
