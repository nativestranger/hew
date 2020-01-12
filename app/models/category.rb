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
#  index_categories_on_name  (name) UNIQUE
#

class Category < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true

  alias_attribute :to_s, :name

  def self.default # TODO: determine...
    [
      new_media,
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

  def self.new_media
    find_or_create_by!(name: 'New Media')
  end

  def self.other
    find_or_create_by!(name: 'Other')
  end
end
