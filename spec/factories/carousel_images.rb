# == Schema Information
#
# Table name: carousel_images
#
#  id          :bigint           not null, primary key
#  alt         :string           default(""), not null
#  description :string           default(""), not null
#  name        :string           default(""), not null
#  position    :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  carousel_id :bigint
#
# Indexes
#
#  index_carousel_images_on_carousel_id               (carousel_id)
#  index_carousel_images_on_carousel_id_and_position  (carousel_id,position) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (carousel_id => carousels.id)
#

include ActionDispatch::TestProcess # for seed

FactoryBot.define do
  factory :carousel_image do
    trait :van do
      img_upload { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'images', 'van.jpg')) }
    end
    trait :bathroom do
      img_upload { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'images', 'bathroom.jpg')) }
    end
    trait :face do
      img_upload { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'images', 'face.jpg')) }
    end
  end
end
