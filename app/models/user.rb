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

  has_many :chat_users
  has_many :chats, through: :chat_users

  before_save :set_gravatar_url, if: :email_changed?

  validates :first_name, presence: true
  validates :last_name, presence: true

  validates :artist_website, url: { allow_blank: true }
  validates :instagram_url, url: { allow_blank: true }

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def set_gravatar_url
    gravatar_id = Digest::MD5.hexdigest(email.downcase)
    self.gravatar_url = "//gravatar.com/avatar/#{gravatar_id}.png?d=retro&s=48"
  end
end
