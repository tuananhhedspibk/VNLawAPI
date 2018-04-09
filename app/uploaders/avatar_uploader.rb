class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{mounted_as}/#{model.id}"
  end

  def default_url(*args)
    ActionController::Base.helpers.asset_path("default-ava/" + [args].compact.join('_'))
  end

  version :thumb do
    process resize_to_fit: [150, 150]
  end

  version :thumb_medium do
    process resize_to_fit: [50, 50]
  end

  version :thumb_small do
    process resize_to_fit: [42, 42]
  end

  def extension_whitelist
    %w(jpg jpeg gif png pdf)
  end
end
