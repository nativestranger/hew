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
