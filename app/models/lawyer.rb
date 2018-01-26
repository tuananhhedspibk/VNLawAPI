class Lawyer < ApplicationRecord
  has_many :lawyer_specializes, dependent: :destroy
  has_many :specializations, through: :lawyer_specializes

  CREATE_PARAMS = %i(
    name
    fb_id
    rate
    intro
    cost
    view_count
  ).freeze

  searchkick word_start: [:name], suggest: [:name],
    batch_size: 50
end
