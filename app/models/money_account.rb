class MoneyAccount < ApplicationRecord
  UPDATE_PARAMS = [:ammount].freeze

  belongs_to :profile

  has_many :deposit_histories, dependent: :destroy
end
