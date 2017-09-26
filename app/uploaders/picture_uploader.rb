class PictureUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick
  process resize_to_limit: [1000000, 262]

  # AWS for production and local upload folder for development
  if Rails.env.production?
    storage :fog
  else
    storage :file
  end

  # Directory for where uploaded files will be stored.
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Uploaders extension white list
  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
