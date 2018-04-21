class Profile < ApplicationRecord
  mount_uploader :avatar, AvatarUploader

  belongs_to :user

  has_one :money_account, dependent: :destroy

  validates :userName, presence: true
  validates :displayName, presence: true

  accepts_nested_attributes_for :money_account, update_only: true,
    allow_destroy: true

  searchkick word_start: [:displayName], suggest: [:displayName],
    batch_size: 50
end
