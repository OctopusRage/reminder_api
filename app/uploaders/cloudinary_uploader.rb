class CloudinaryUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    Rails.root.join('tmp/cloudinary')
  end

end
