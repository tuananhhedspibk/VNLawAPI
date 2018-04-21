class Api::V1::MoneyAccountsController < Api::V1::ApplicationController
  acts_as_token_authentication_handler_for User

  before_action :get_money_account

  def show
    response_show_success
  end

  def update
    @new_ammount = money_account.ammount - params[:money_account][:ammount].to_i

    if new_ammount < 0 || params[:money_account][:ammount].to_i < 0
      response_update_failed
    else
      params[:money_account][:ammount] = new_ammount
      return response_update_success if money_account.update_attributes money_account_params
      response_update_failed
    end
  end

  private

  attr_reader :money_account, :new_ammount

  def response_show_success
    render json: {
      balance: money_account.ammount
    }
  end

  def response_update_success
    render json: {
      balance: money_account.ammount,
      updated_at: money_account.updated_at
    }, status: :ok
  end

  def response_update_failed
    render json: {
      message: I18n.t("app.api.messages.update_failed",
        authentication_keys: "money_account")
    }, status: :unprocessable_entity
  end

  def get_money_account
    @money_account = current_user.money_account
  end

  def money_account_params
    params.require(:money_account).permit MoneyAccount::UPDATE_PARAMS
  end
end
