class LawyerSpecialize < ApplicationRecord
  CREATE_PARAMS = [:role_id, :lid].freeze

  belongs_to :lawyer
  belongs_to :specialization
end
