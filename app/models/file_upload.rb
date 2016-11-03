class FileUpload < ActiveRecord::Base
  IMAGE_EXTENSIONS = %w( .jpg .png .gif .bmp .tiff .ico .pdf .eps .psd .svg .webp )

  belongs_to :uploader, polymorphic: true

  before_create :set_hash_id, :set_name

  mount_uploader :raw, CloudinaryUploader

  validates :uploader_id, :uploader_type, presence: true

  def image?
    IMAGE_EXTENSIONS.include? ext.downcase
  end

  def proxy_url(base_url = nil)
    "#{base_url}/files/upload/#{hash_id}/#{name}#{ext}"
  end

  def proxy_avatar
    "/files/avatars/#{hash_id}/#{name}#{ext}"
  end

  def fetch_url(options={})
    return url unless image?
    if ext = options[:ext]
      url_split = url.split('.')
      url_split.pop
      url_split << ext
      self.url = url_split.join('.')
    end
    if trans = options[:trans]
      url_split = url.split('/upload/')
      self.url = "#{url_split.first}/upload/#{trans}/#{url_split.last}"
    end
    url
  end

  def as_json(params={})
    base_url = params[:base_url]
    {
      hash_id: hash_id,
      name: name,
      ext: ext,
      url: proxy_url(base_url)
    }
  end

  private

    def set_hash_id
      seed = "--#{rand(10000)}--#{Time.now}--"
      self.hash_id = Digest::SHA256.hexdigest(seed)
    end

    def set_extension
      ext = File.extname(raw.current_path).to_s

      if ext[-1, 1] == '_'
        self.ext = ext[0..-2]
      else
        self.ext = ext
      end
    end

    def set_name
      set_extension
      name = File.basename(raw.current_path, File.extname(raw.current_path))
      self.name = name.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
    end
end
