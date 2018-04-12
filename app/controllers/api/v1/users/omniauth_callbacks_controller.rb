module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    before_action :user_from_omniauth, only: :google_oauth2

    attr_reader :user

    def facebook
      @user = User.from_omniauth request.env["omniauth.auth"]
      sign_in_and_redirect user, event: :authentication
    end

    def google_oauth2
      env_omni_auth = request.env["omniauth.auth"]
      if user.persisted?
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success",
          kind: "Google"
        sign_in_and_redirect user, event: :authentication
      else
        session["devise.google_data"] = env_omni_auth.except :extra
        redirect_to new_user_registration_url,
          alert: user.errors.full_messages.join("\n")
      end
    end

    def failure
      render json: {
        message: I18n.t("app.api.messages.not_authorized")
      }, status: :unauthorized
    end

    private

    def user_from_omniauth
      env_omni_auth = request.env["omniauth.auth"]
      @user = User.from_omniauth env_omni_auth
    end
  end
end
