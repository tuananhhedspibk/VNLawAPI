class FileUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{mounted_as}/#{model.room.id}"
  end

  version :thumb, :if => :image? do
    process resize_to_fit: [150, 150]
  end

  version :thumb_medium, :if => :image? do
    process resize_to_fit: [100, 100]
  end

  version :thumb_small, :if => :image? do
    process resize_to_fit: [50, 50]
  end

  def extension_whitelist
    %w(jpg jpeg gif png pdf txt doc)
  end

  protected

  def image? new_file
    new_file.content_type.start_with? "image"
  end
end
