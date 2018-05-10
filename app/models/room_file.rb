class RoomFile < ApplicationRecord
  mount_uploader :file, FileUploader

  CREATE_PARAMS = [:room_id, :content_type_id, :file].freeze

  belongs_to :room
end
