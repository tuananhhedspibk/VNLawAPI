class ApplicationController < ActionController::Base
  before_action :restrict_access

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
