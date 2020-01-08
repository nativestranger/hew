# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  name       :string           default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_categories_on_name  (name)
#

class Category < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true

  def self.default # TODO: determine...
    [
      painting,
      drawing,
      other
    ]
  end

  def self.painting
    find_or_create_by!(name: 'Painting')
  end

  def self.drawing
    find_or_create_by!(name: 'Drawing')
  end

  def self.other
    find_or_create_by!(name: 'Other')
  end
end
