ApplicationRecord.transaction do
  admin = FactoryBot.create(
    :user,
    email: 'admin@example.com',
    password: 'password',
    is_admin: true
  )
  admin.confirm

  user = FactoryBot.create(
    :user,
    email: 'user@example.com',
    password: 'password',
    is_artist: true,
    is_curator: true
  )
  user.confirm

  venue = FactoryBot.create(:venue, user: admin)

  FactoryBot.create(:call, user: admin, is_public: true, is_approved: true, external: true)
  FactoryBot.create(:call, :categories, user: admin, is_public: true, is_approved: true, external: true)

  FactoryBot.create(:call, :accepting_entries, :categories, user: admin, venue: venue, is_public: true, is_approved: true, external: true)
  FactoryBot.create(:call, :categories, :accepting_entries, :categories, user: admin, venue: venue, is_public: true, is_approved: true, external: true)

  2.times do
    FactoryBot.create(:call, user: admin, is_public: true, is_approved: true)
  end

  Call.internal.each do |call|
    rand(3..12).times { FactoryBot.create(:entry, call: call, creation_status: 'submitted') }
    FactoryBot.create(:entry, call: call, user: [user, FactoryBot.create(:user, is_artist: true)].sample, creation_status: 'submitted')
  end

  # not applied to
  FactoryBot.create(:call, user: admin, is_public: true, is_approved: true)
  12.times { FactoryBot.create(:call, :accepting_entries, is_public: true, is_approved: true) }
  ###

  # little_cats = FactoryBot.create(:piece, user: user, title: 'Little Cats')
  # FactoryBot.create(:piece_image, piece: little_cats, name: 'kitten1', image_fixture_path: 'little_cats/kitten1.jpg')
  # FactoryBot.create(:piece_image, piece: little_cats, name: 'kitten2', image_fixture_path: 'little_cats/kitten2.jpg')
  # FactoryBot.create(:piece_image, piece: little_cats, name: 'kitten3', image_fixture_path: 'little_cats/kitten3.jpg')
  # FactoryBot.create(:piece_image, piece: little_cats, name: 'kitten4', image_fixture_path: 'little_cats/kitten4.jpg')
  # FactoryBot.create(:piece_image, piece: little_cats, name: 'kitten5', image_fixture_path: 'little_cats/kitten5.jpg')
  # FactoryBot.create(:piece_image, piece: little_cats, name: 'kitten6', image_fixture_path: 'little_cats/kitten6.jpg')

  # big_cats = FactoryBot.create(:piece, user: user, title: 'Big Cats')
  # FactoryBot.create(:piece_image, piece: big_cats, name: 'black_panther1', image_fixture_path: 'big_cats/black_panther1.jpg')
  # FactoryBot.create(:piece_image, piece: big_cats, name: 'leopard1', image_fixture_path: 'big_cats/leopard1.jpg')
  # FactoryBot.create(:piece_image, piece: big_cats, name: 'lion1', image_fixture_path: 'big_cats/lion1.jpg')
  # FactoryBot.create(:piece_image, piece: big_cats, name: 'lynx1', image_fixture_path: 'big_cats/lynx1.jpg')
  # FactoryBot.create(:piece_image, piece: big_cats, name: 'wildcat3', image_fixture_path: 'big_cats/wildcat3.jpg')

  # little_dogs = FactoryBot.create(:piece, user: user, title: 'Little Dogs')
  # FactoryBot.create(:piece_image, piece: little_dogs, name: 'puppy1', image_fixture_path: 'little_dogs/puppy1.jpg')
  # FactoryBot.create(:piece_image, piece: little_dogs, name: 'puppy2', image_fixture_path: 'little_dogs/puppy2.jpg')
  # FactoryBot.create(:piece_image, piece: little_dogs, name: 'puppy3', image_fixture_path: 'little_dogs/puppy3.jpg')

  # big_dogs = FactoryBot.create(:piece, user: user, title: 'Big Dogs')
  # FactoryBot.create(:piece_image, piece: big_dogs, name: 'big_dog1', image_fixture_path: 'big_dogs/big_dog1.jpg')
  # FactoryBot.create(:piece_image, piece: big_dogs, name: 'big_dog2', image_fixture_path: 'big_dogs/big_dog2.jpg')
  # FactoryBot.create(:piece_image, piece: big_dogs, name: 'big_dog3', image_fixture_path: 'big_dogs/big_dog3.jpg')
  # FactoryBot.create(:piece_image, piece: big_dogs, name: 'big_dog4', image_fixture_path: 'big_dogs/big_dog4.jpg')
end