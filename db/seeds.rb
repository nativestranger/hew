# frozen_string_literal: true

en_admin = User.new(email: 'en@example.com', password: 'password')
en_admin.save!
en_admin.confirm

es_admin = User.new(email: 'es@example.com', password: 'password', locale: 'es')
es_admin.save!
es_admin.confirm
