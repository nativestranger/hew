en_admin = FactoryBot.create(:user, email: 'en@example.com', password: 'password')
en_admin.confirm

# es_admin = FactoryBot.create(:user, 'es@example.com', password: 'password', locale: 'es')
# es_admin.confirm

require_relative 'seed_states_and_cities'

venue = FactoryBot.create(:venue, user: en_admin)

3.times { FactoryBot.create(:show, user: en_admin, venue: venue, is_public: true) }
FactoryBot.create(:show, user: en_admin, venue: venue)
FactoryBot.create(:show, :current, user: en_admin, venue: venue, is_public: true)
2.times { FactoryBot.create(:show, :old, user: en_admin, venue: venue, is_public: true) }

# 3.times { FactoryBot.create(:show, is_public: true) }

Show.all.each do |show|
  rand(3..8).times { FactoryBot.create(:show_application, show: show) }
end
