module UserSessionHelper
  def authorize_user
    render json: {
      status: 'fail',
      message: 'Unauthorized Access',
      data: {
        message: 'Unauthorized Access'
      }
    }, status: 403 unless current_user
  end

  def current_user
    token_authentication(:user)
  end

  def token_authentication(class_name)
    klass = class_name.to_s.classify.constantize
    authenticate_with_http_token do |token, options|
      user = klass.find_by(authentication_token: token)

      if (class_name.to_s == 'user') && user != nil
        user.update_attribute(:last_login_at, Time.zone.now)
      end

      return user
    end
  end

end
