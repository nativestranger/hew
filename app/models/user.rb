# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  artist_statement       :text             default(""), not null
#  artist_website         :string           default(""), not null
#  bio                    :text             default(""), not null
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  first_name             :string           default(""), not null
#  gravatar_url           :string           default(""), not null
#  instagram_url          :string           default(""), not null
#  is_admin               :boolean          default(FALSE), not null
#  is_artist              :boolean          default(FALSE), not null
#  is_curator             :boolean          default(FALSE), not null
#  last_name              :string           default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  locale                 :string           default("en"), not null
#  locked_at              :datetime
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string
#  unlock_token           :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#

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
  has_many :show_applications, dependent: :destroy

  has_many :chat_users
  has_many :chats, through: :chat_users

  before_save :set_gravatar_url, if: :email_changed?

  validates :first_name, presence: true
  validates :last_name, presence: true

  validates :artist_website, url: { allow_blank: true, public_suffix: true }
  validates :instagram_url, url: { allow_blank: true, public_suffix: true }

  scope :admins, -> { where(is_admin: true) }

  def full_name
    "#{first_name} #{last_name}"
  end

  def avatar_url
    if avatar.attached?
      Rails.application.routes.url_helpers.rails_blob_url(avatar)
    else
      gravatar_url
    end
  end

  private

  def set_gravatar_url
    gravatar_id = Digest::MD5.hexdigest(email.downcase)
    self.gravatar_url = "//gravatar.com/avatar/#{gravatar_id}.png?d=retro&s=200"
  end
end
