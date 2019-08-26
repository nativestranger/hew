class Country < ApplicationRecord
  alias_attribute :to_s, :name
  has_many :states, dependent: :destroy
  validates :name, presence: true

  def self.united_states
    find_or_create_by!(name: 'United States')
  end

  def self.mexico
    find_or_create_by!(name: 'Mexico')
  end
end
