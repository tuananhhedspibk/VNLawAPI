class Api::V1::SessionsController < Devise::SessionsController
  skip_before_action :verify_signed_out_user, only: :destroy
  protect_from_forgery with: :null_session

  before_action :load_user, only: :create
  before_action :valid_token, only: :destroy

  def create
    if user.valid_password? login_params[:password]
      sign_in "user", user
      response_create_data
    else
      invalid_login_attempt
    end
  end

  def destroy
    sign_out user
    user.generate_new_authentication_token
    response_destroy
  end

  private

  attr_reader :user

  def response_create_data
    render json: {
      message: I18n.t("devise.sessions.signed_in"),
      userToken: user.authentication_token,
      userName: user.profile.userName,
      role: user.role.name
    }, status: :ok
  end

  def response_destroy
    render json: {
      message: I18n.t("devise.sessions.signed_out")
    }, status: :ok
  end

  def login_params
    params.require(:login).permit :email, :password
  end

  def invalid_login_attempt
    render json: {
      message: I18n.t("devise.failure.invalid", authentication_keys: "email")
    }, status: :unauthorized
  end

  def load_user
    @user =
      User.find_for_database_authentication email: login_params[:email]

    return if user
    render json: {
      message: I18n.t("devise.failure.invalid", authentication_keys: "email")
    }, status: :not_found
  end

  def valid_token
    @user =
      User.find_by authentication_token: request.headers["X-User-Token"]

    return if user
    render json: {
      message: I18n.t("app.api.messages.invalid_token")
    }, status: :not_found
  end
end
