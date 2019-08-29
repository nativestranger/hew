admin = FactoryBot.create(:user, email: 'admin@example.com', password: 'password', is_admin: true)
admin.confirm

user = FactoryBot.create(:user, email: 'user@example.com', password: 'password', is_artist: true, is_curator: true)
user.confirm

venue = FactoryBot.create(:venue, user: admin)

3.times { FactoryBot.create(:show, user: admin, venue: venue, is_public: true) }
FactoryBot.create(:show, user: admin, venue: venue)
FactoryBot.create(:show, :current, user: admin, venue: venue, is_public: true)
2.times { FactoryBot.create(:show, :old, user: admin, venue: venue, is_public: true) }

Show.all.each do |show|
  rand(3..4).times { FactoryBot.create(:show_application, show: show) }
  FactoryBot.create(:show_application, show: show, user: user)
end
