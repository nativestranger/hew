include ActionDispatch::TestProcess # for seed

FactoryBot.define do
  factory :gallery_image do

    trait :van do
      img_upload { fixture_file_upload(Rails.root.join('app', 'assets', 'images', 'van.jpg')) }
    end
    trait :bathroom do
      img_upload { fixture_file_upload(Rails.root.join('app', 'assets', 'images', 'bathroom.jpg')) }
    end
    trait :face do
      img_upload { fixture_file_upload(Rails.root.join('app', 'assets', 'images', 'face.jpg')) }
    end
  end
end
