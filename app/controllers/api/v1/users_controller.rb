class Api::V1::UsersController < Api::V1::ApplicationController
  acts_as_token_authentication_handler_for User, only: :update

  before_action :find_object
  before_action :find_acc, only: :show

  authorize_resource
  skip_authorize_resource only: :show

  def show
    response_show_succcess
  end

  def update
    return response_update_success if user.update_attributes user_params
    response_update_fail
  end

  private

  attr_reader :user, :profile, :acc

  def response_show_succcess
    render json: {
      user_info: {
        email: user.email,
        profile: user.profile.as_json(except: :user_id),
        status: user.status,
        mn_acc: acc.as_json(except: :profile_id)
      }
    }, status: :ok
  end

  def response_update_success
    render json: {
      message: I18n.t("app.api.messages.update_success",
        authentication_keys: "user"),
      profile: user.profile.as_json(except: :user_id)
    }, status: :ok
  end

  def response_update_fail
    render json: {
      message: I18n.t("app.api.messages.update_failed",
        authentication_keys: "user")
    }, status: :unprocessable_entity
  end

  def find_acc
    if request.headers["X-User-Token"]
      if request.headers["X-User-Token"] == user.authentication_token
        @acc = profile.money_account
      end
    end
  end

  def find_object
    @profile = Profile.find_by userName: params[:id]
    if !profile
      render json: {
        messages: I18n.t("app.api.messages.not_found",
          authentication_keys: "user")
      }, status: :not_found
    else
      @user = User.find_by id: profile.user_id
      if !user || user.role == 1
        render json: {
          messages: I18n.t("app.api.messages.not_found",
            authentication_keys: "user")
        }, status: :not_found
      else
        return
      end
    end
  end

  def user_params
    params.require(:users).permit User::UPDATE_PARAMS
  end
end
