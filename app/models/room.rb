class Room < ApplicationRecord
  CREATE_PARAMS = [:user_id, :lawyer_id, :description].freeze  
  UPDATE_PARAMS = [:description].freeze

  belongs_to :lawyer
  belongs_to :user

  has_many :tasks, dependent: :destroy
  has_many :payments, dependent: :destroy

  has_many :room_files, dependent: :destroy
end
