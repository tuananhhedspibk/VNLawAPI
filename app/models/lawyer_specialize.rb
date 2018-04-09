class LawyerSpecialize < ApplicationRecord
  CREATE_PARAMS = [:lawyer_id, :specialization_id].freeze

  belongs_to :lawyer
  belongs_to :specialization
end
