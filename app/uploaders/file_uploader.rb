class FileUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{mounted_as}/#{model.room.id}"
  end

  version :thumb do
    process resize_to_fit: [150, 150]
  end

  version :thumb_medium do
    process resize_to_fit: [100, 100]
  end

  version :thumb_small do
    process resize_to_fit: [50, 50]
  end

  def extension_whitelist
    %w(jpg jpeg gif png pdf txt doc)
  end
end
