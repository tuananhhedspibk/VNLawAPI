class Api::V1::DepositHistoriessController < Api::V1::ApplicationController
  before_action :find_profile
  before_action :find_acc

  authorize_resource

  def index
    response_deposit_histories_idx
  end

  def create
    @dep = DepositHistory.new deposit_history_params

    if dep.save ? response_create_success : response_create_failed
  end

  private

  attr_reader :profile, :acc, :dep

  def find_acc
    @acc = MoneyAccount.find_by pid: profile.id
    authorized! :read, acc
  end

  def find_profile
    @profile = Profile.find_by userName: params[:user_name]
    return if profile
    render json: {
      message: I18n.t("app.api.messages.not_found",
        authentication_keys: "profile")
    }, status: :not_found
  end

  def response_deposit_histories_idx
    render json: {
      d_h: acc.deposit_histories
    }, status: :ok
  end

  def response_create_success
    render json: {
      message: I18n.t("app.api.messages.create_success",
        authentication_keys: "deposit"),
      dep: dep
    }, status: :ok
  end

  def response_create_failed
    render json: {
      message: I18n.t("app.api.messages.create_failed")
    }, status: :unprocessable_entity
  end

  def deposit_history_params
    params.require(:deposit_history).permit DepositHistory::CREATE_PARAMS
  end
end
