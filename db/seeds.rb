en_admin = User.new(email: 'en@example.com', password: 'password')
en_admin.save!
en_admin.confirm

# es_admin = User.new(email: 'es@example.com', password: 'password', locale: 'es')
# es_admin.save!
# es_admin.confirm

# carousel = Carousel.new(name: 'some paintings', user: en_admin)
# carousel.save!
# FactoryBot.create(:carousel_image, :van, carousel: carousel, position: 1)
# FactoryBot.create(:carousel_image, :bathroom, carousel: carousel, position: 2)
# FactoryBot.create(:carousel_image, :face, carousel: carousel, position: 3)

require_relative 'seed_states_and_cities'

venue = FactoryBot.create(:venue, user: en_admin)

3.times { FactoryBot.create(:show, user: en_admin, venue: venue, is_public: true) }
FactoryBot.create(:show, user: en_admin, venue: venue)
FactoryBot.create(:show, :current, user: en_admin, venue: venue, is_public: true)
2.times { FactoryBot.create(:show, :old, user: en_admin, venue: venue, is_public: true) }

Show.all.each do |show|
  rand(20..50).times { FactoryBot.create(:show_application, show: show) }
end
