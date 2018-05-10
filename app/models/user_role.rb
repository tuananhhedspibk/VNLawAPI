class UserRole < ApplicationRecord
  CREATE_PARAMS = [:role_id, :user_id].freeze

  belongs_to :user
  belongs_to :role
end
