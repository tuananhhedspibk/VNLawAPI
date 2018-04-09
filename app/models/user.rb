class User < ApplicationRecord
  acts_as_token_authenticatable

  mount_uploader :avatar, AvatarUploader

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  REGISTRATION_PARAMS = [:id, :email, :password, :password_confirmation,
    profile_attributes: [:displayName, :birthday, :photoURL, :userName],
    user_role_attributes: [:role_id]].freeze
  UPDATE_PARAMS = [profile_attributes: [:displayName,
    :birthday, :avatar]].freeze

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable

  has_one :lawyer, dependent: :destroy
  has_one :profile, dependent: :destroy
  has_one :money_account, through: :profile
  has_one :user_role, dependent: :destroy
  has_one :role, through: :user_role

  has_many :reviews, dependent: :destroy
  has_many :rooms, dependent: :destroy

  validates :email, presence: true, length: {maximum: 50},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}

  accepts_nested_attributes_for :profile, :user_role,
    update_only: true, allow_destroy: true

  def current_user? user
    self == user
  end

  def room_member? room
    user.room_ids.include? room.id
  end

  def generate_new_authentication_token
    token = User.generate_unique_secure_token
    update_attributes authentication_token: token
  end
end
