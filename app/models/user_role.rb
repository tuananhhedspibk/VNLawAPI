class UserRole < ApplicationRecord
  CREATE_PARAMS = [:rid, :uid].freeze

  belongs_to :user
  belongs_to :role
end
