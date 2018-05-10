class Api::V1::ApplicationController < ActionController::API
  before_action :restrict_access

  include CanCan::ControllerAdditions

  rescue_from CanCan::AccessDenied do
    render json: {
      message: I18n.t("app.api.messages.not_authorized")
    }, status: :unauthorized
  end
  
  private

  def restrict_access
    if request.headers["X-Api-Token"]
      token_hashed = Digest::SHA256.hexdigest request.headers["X-Api-Token"]
      api_key = ApiKey.find_by_access_token token_hashed
      head :unauthorized unless api_key
    else
      head :unauthorized
    end
  end
end
