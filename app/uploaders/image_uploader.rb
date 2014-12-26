# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick

  def extension_white_list
    %w(jpg jpeg gif png)
  end


  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{version_folder}/#{guid_partition}"
  end


  def filename
    #guid means some number, and file.extension we use for .jpg or other format if original
    "#{guid}.#{file.extension}" if original_filename
  end
  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :resize_to_fit => [50, 50]
  # end

  # versions - post

  version :p700x, if: :post? do
    process resize_to_limit: [700, 3000]
  end

  version :p230x, if: :post?, from_version: :p700x do
    process resize_to_fit: [230, -1]
  end

  version :p70x, if: :post?, from_version: :p230x do
    process resize_to_fit: [70, -1]
  end


  # versions - avatar

  version :a230, if: :avatar? do
    process resize_to_fill: [230, 230, 'North']
  end

  version :a70, if: :avatar?, from_version: :a230 do
    process resize_to_limit: [70, 70]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

  # processes
  process quality: 85
  #quality which we use, for adjust image quality its default method in minimagic or imagemagick
  process :fix_exif_rotation
  #fix_exif_rotation is a hack, which we use in phone, suppose you take photo by phone in -90 degree,
  #this hack adjust your pictures in right view.


  protected

  def guid
    model.guid
  end

  def post?(file)
    model.post?
  end

  def avatar?(file)
    model.avatar?
  end

  def version_folder
    #in this method we use version_name, which means take this version_name which we create or use original
    version_name || :original
  end

  def guid_partition
    #in this function guid_partition means divide any guid number to this format.
    guid.scan(/.{2}/).first(2).join('/')
  end

  def store_asset_attributes
    if @file
      img = ::MiniMagick::Image::read(File.binread(@file.file))
      if model
        model.asset_width = img[:width] if model.asset_width.blank?
        model.asset_height = img[:height] if model.asset_height.blank?
        model.asset_file_size = img[:size] if model.asset_file_size.blank?
        model.asset_content_type = img.mime_type if model.asset_content_type.blank?
      end
    end
  end

end
