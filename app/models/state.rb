class State < ApplicationRecord
  alias_attribute :to_s, :name
  belongs_to :country
  has_many :cities
  validates :name, presence: true
end
