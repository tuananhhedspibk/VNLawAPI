class Api::V1::RegistrationsController < Devise::RegistrationsController
  protect_from_forgery with: :null_session

  def create
    @user = User.new user_params

    begin
      user.save!
      user.profile.build_money_account.save!
      response_create_success
    rescue
      response_create_fail
    end
  end

  private

  attr_reader :user

  def response_create_success
    render json: {
      message: I18n.t("app.api.messages.users.sign_up_success"),
      user: user.as_json(except: :id),
      role: user.role.name
    }, status: :ok
  end

  def response_create_fail
    render json: {
      message: I18n.t("app.api.messages.users.sign_up_fail")
    }, status: :unprocessable_entity
  end

  def user_params
    params.require(:signup).permit User::REGISTRATION_PARAMS
  end
end
