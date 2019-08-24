class City < ApplicationRecord
  alias_attribute :to_s, :name
  belongs_to :state
  has_many :addresses
  validates :name, presence: true

  def self.mexico_city
    find_or_create_by!(name: 'Mexico City', state: Country.mexico.states.find_by(name: 'Mexico City'))
  end
end
