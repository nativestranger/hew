# frozen_string_literal: true

en_admin = User.new(email: 'en@example.com', password: 'password')
en_admin.save!
en_admin.confirm

es_admin = User.new(email: 'es@example.com', password: 'password', locale: 'es')
es_admin.save!
es_admin.confirm

gallery = Gallery.new(name: 'some paintings', user: en_admin)
gallery.save!

FactoryBot.create(:gallery_image, :van, gallery: gallery, position: 1)
FactoryBot.create(:gallery_image, :bathroom, gallery: gallery, position: 2)
FactoryBot.create(:gallery_image, :face, gallery: gallery, position: 3)
