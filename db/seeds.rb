admin = FactoryBot.create(:user, email: 'admin@example.com', password: 'password', is_admin: true)
admin.confirm

user = FactoryBot.create(:user, email: 'user@example.com', password: 'password', is_artist: true, is_curator: true)
user.confirm

little_cats = FactoryBot.create(:carousel, user: user, name: 'Little Cats')
FactoryBot.create(:carousel_image, carousel: little_cats, name: 'kitten1', image_fixture_path: 'little_cats/kitten1.jpg')
FactoryBot.create(:carousel_image, carousel: little_cats, name: 'kitten2', image_fixture_path: 'little_cats/kitten2.jpg')
FactoryBot.create(:carousel_image, carousel: little_cats, name: 'kitten3', image_fixture_path: 'little_cats/kitten3.jpg')
FactoryBot.create(:carousel_image, carousel: little_cats, name: 'kitten4', image_fixture_path: 'little_cats/kitten4.jpg')
FactoryBot.create(:carousel_image, carousel: little_cats, name: 'kitten5', image_fixture_path: 'little_cats/kitten5.jpg')
FactoryBot.create(:carousel_image, carousel: little_cats, name: 'kitten6', image_fixture_path: 'little_cats/kitten6.jpg')

big_cats = FactoryBot.create(:carousel, user: user, name: 'Big Cats')
FactoryBot.create(:carousel_image, carousel: big_cats, name: 'black_panther1', image_fixture_path: 'big_cats/black_panther1.jpg')
FactoryBot.create(:carousel_image, carousel: big_cats, name: 'leopard1', image_fixture_path: 'big_cats/leopard1.jpg')
FactoryBot.create(:carousel_image, carousel: big_cats, name: 'lion1', image_fixture_path: 'big_cats/lion1.jpg')
FactoryBot.create(:carousel_image, carousel: big_cats, name: 'lynx1', image_fixture_path: 'big_cats/lynx1.jpg')
FactoryBot.create(:carousel_image, carousel: big_cats, name: 'wildcat3', image_fixture_path: 'big_cats/wildcat3.jpg')

little_dogs = FactoryBot.create(:carousel, user: user, name: 'Little Dogs')
FactoryBot.create(:carousel_image, carousel: little_dogs, name: 'puppy1', image_fixture_path: 'little_dogs/puppy1.jpg')
FactoryBot.create(:carousel_image, carousel: little_dogs, name: 'puppy2', image_fixture_path: 'little_dogs/puppy2.jpg')
FactoryBot.create(:carousel_image, carousel: little_dogs, name: 'puppy3', image_fixture_path: 'little_dogs/puppy3.jpg')

big_dogs = FactoryBot.create(:carousel, user: user, name: 'Big Dogs')
FactoryBot.create(:carousel_image, carousel: big_dogs, name: 'big_dog1', image_fixture_path: 'big_dogs/big_dog1.jpg')
FactoryBot.create(:carousel_image, carousel: big_dogs, name: 'big_dog2', image_fixture_path: 'big_dogs/big_dog2.jpg')
FactoryBot.create(:carousel_image, carousel: big_dogs, name: 'big_dog3', image_fixture_path: 'big_dogs/big_dog3.jpg')
FactoryBot.create(:carousel_image, carousel: big_dogs, name: 'big_dog4', image_fixture_path: 'big_dogs/big_dog4.jpg')

venue = FactoryBot.create(:venue, user: admin)

2.times { FactoryBot.create(:call, is_public: true, is_approved: true) }
3.times { FactoryBot.create(:call, user: admin, venue: venue, is_public: true, is_approved: true) }
FactoryBot.create(:call, user: admin, venue: venue)
FactoryBot.create(:call, :current, user: admin, venue: venue, is_public: true)
2.times { FactoryBot.create(:call, :old, user: admin, venue: venue, is_public: true) }

Call.all.each do |call|
  rand(3..4).times { FactoryBot.create(:call_application, call: call) }
  FactoryBot.create(:call_application, call: call, user: user)
end

admin.calls.first.update!(is_approved: true)
