class Api::SessionsController < Api::BaseController
  skip_before_filter :verify_authenticity_token

  def create
    user = User.find_for_database_authentication(
      email: params[:email]
    )
    return invalid_login_attempt unless user

    if user.valid_password? params[:password]
      render json: {
        success: true,
        auth_token: user.authentication_token,
        email: user.email
      }
      return
    end
    invalid_login_attempt
  end

  private

  def invalid_login_attempt
    warden.custom_failure!
    render json: {
      success: false,
      message: "Error with your login or password"
    }, status: 401
  end
end
