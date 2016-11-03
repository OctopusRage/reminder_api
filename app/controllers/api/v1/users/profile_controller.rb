class Api::V1::Users::ProfileController < ApplicationController
  before_action :authorize_user
  def show
    user = current_user
    render json: {
      status: 'success', 
      data: user
    }, status: 200
  end
end