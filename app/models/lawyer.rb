class Lawyer < ApplicationRecord
  UPDATE_PARAMS = [:achievement, :cardNumber,
    :certificate, :education, :intro, :price, :exp,
    :workPlace, profile_attributes: [:displayName,
    :birthday, :photoURL]].freeze
  CREATE_PARAMS = [:user_id, :achievement, :cardNumber,
    :certificate, :education, :intro, :price, :exp,
    :workPlace].freeze

  belongs_to :user
  has_one :profile, through: :user
  has_many :rooms, dependent: :destroy
  has_many :reviews, dependent: :destroy

  has_many :lawyer_specializes, dependent: :destroy
  has_many :specializations, through: :lawyer_specializes

  accepts_nested_attributes_for :profile, update_only: true
end
