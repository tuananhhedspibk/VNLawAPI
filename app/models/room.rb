class Room < ApplicationRecord
  CREATE_PARAMS = [:id, :user_id, :lawyer_id, :description].freeze  
  UPDATE_PARAMS = [:description].freeze

  belongs_to :lawyer
  belongs_to :user

  has_many :tasks, dependent: :destroy
  has_many :payments, dependent: :destroy
end
