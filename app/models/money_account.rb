class MoneyAccount < ApplicationRecord
  belongs_to :profile

  has_many :deposit_histories, dependent: :destroy
end
