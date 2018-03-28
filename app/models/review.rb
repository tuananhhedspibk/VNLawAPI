class Review < ApplicationRecord
  CREATE_PARAMS = [:uid, :lid, :content, :star].freeze
  UPDATE_PARAMS = [:content, :star].freeze

  belongs_to :user
  belongs_to :lawyer

  validates :content, presence: true, allow_blank: false
end
