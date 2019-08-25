class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :timeoutable, :trackable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable # , :omniauthable

  has_one_attached :avatar

  has_many :carousels, dependent: :destroy
  has_many :venues, dependent: :destroy
  has_many :shows, dependent: :destroy

  before_save :set_gravatar_url, if: :email_changed?

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def set_gravatar_url
    gravatar_id = Digest::MD5.hexdigest(email.downcase)
    self.gravatar_url = "//gravatar.com/avatar/#{gravatar_id}.png?d=retro&s=48"
  end
end
