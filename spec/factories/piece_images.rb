# == Schema Information
#
# Table name: piece_images
#
#  id          :bigint           not null, primary key
#  alt         :string           default(""), not null
#  description :string           default(""), not null
#  name        :string           default(""), not null
#  position    :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  piece_id    :bigint
#
# Indexes
#
#  index_piece_images_on_piece_id               (piece_id)
#  index_piece_images_on_piece_id_and_position  (piece_id,position) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (piece_id => pieces.id)
#

include ActionDispatch::TestProcess # for seed

FactoryBot.define do
  factory :piece_image do
    transient do
      image_fixture_path {}
    end

    after(:build) do |instance, evaluator|
      if evaluator.image_fixture_path
        instance.img_upload = \
          fixture_file_upload(Rails.root.join('spec', 'fixtures', 'images', *evaluator.image_fixture_path.split('/')))
      end
    end
  end
end
