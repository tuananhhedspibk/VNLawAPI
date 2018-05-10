class Task < ApplicationRecord
  CREATE_PARAMS = [:room_id, :content].freeze
  UPDATE_PARAMS = [:content, :status].freeze

  belongs_to :room
  enum status: %i(Doing Done).freeze
end
