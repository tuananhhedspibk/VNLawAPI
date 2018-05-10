class ContentType < ApplicationRecord
  has_many :room_files

  enum name: %i(File Image).freeze
end
