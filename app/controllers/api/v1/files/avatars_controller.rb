class Api::V1::Files::AvatarsController < ApplicationController
  before_action :authorize_user
  before_action :ensure_raw_file, only: :create

  def create
    file_upload = FileUpload.create!(
      raw: @raw_file,
      uploader: current_user
    )

    render json:{
      status: 'fail',
      message: "only picture can be uploaded"            
    },status:422 and return unless file_upload.image? 

    folder = "images"

    cloudinary = Cloudinary::Uploader.upload(
      file_upload.raw.url, resource_type: 'auto',
      folder: folder)
    file_upload.update!(url: cloudinary['url'])
    current_user.update(avatar_url: file_upload.proxy_avatar)
    render json: {
      status: 'success',
      data: {
        file: file_upload
      }
    }, status: 201, base_url: request.base_url
  end

  def get
    file_upload = FileUpload.find_by!(
      hash_id: params[:id], name: params[:file])
    
    url  = file_upload.fetch_url(
      ext: params[:ext], trans: params[:trans])
    url  = URI.parse(file_upload.url)
    file = Net::HTTP.get_response(url)

    response.headers['Content-Length'] = file.header['Content-Length']

    send_data file.body,
      type: file.content_type, disposition: 'inline'
  end

  private

  def ensure_raw_file
    @raw_file = params[:raw_file]

    render json: {
      status: 'fail',
      message: 'invalid raw file'
    }, status: 422 unless @raw_file
  end
end
