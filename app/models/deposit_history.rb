class DepositHistory < ApplicationRecord
  CREATE_PARAMS = [:accid, :ammount].freeze

  belongs_to :money_account
end
