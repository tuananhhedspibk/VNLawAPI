class Payment < ApplicationRecord
  CREATE_PARAMS = [:rid, :startTime, :endTime, :ammount].freeze

  belongs_to :room
end
