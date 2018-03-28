class Role < ApplicationRecord
  has_many :user_roles
  has_many :users, through: :user_roles

  enum name: %i(User Lawyer).freeze
end
