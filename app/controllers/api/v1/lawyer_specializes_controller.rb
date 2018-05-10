class Api::V1::LawyerSpecializesController < Api::V1::ApplicationController
  acts_as_token_authentication_handler_for User

  before_action :config_lawyer_id, only: :create
  before_action :get_l_sp, only: :destroy

  def create
    @n_l_sp = LawyerSpecialize.new lawyer_specialize_params
    authorize! :create, n_l_sp

    begin
      n_l_sp.save
      response_create_success
    rescue ActiveRecord::RecordNotUnique
     response_create_failed
    end
  end

  def destroy
    authorize! :destroy, l_sp
    return response_destroy_success if l_sp.destroy
    response_destroy_failed
  end

  private

  attr_reader :lawyer, :l_sp, :n_l_sp

  def response_destroy_success
    render json: {
      message: I18n.t("app.api.messages.destroy_success",
        authentication_keys: "lawyer specialization")
    }, status: :ok
  end

  def response_destroy_failed
    render json: {
      message: I18n.t("app.api.messages.destroy_failed",
        authentication_keys: "lawyer specialization")
    }, status: :unprocessable_entity
  end

  def response_create_success
    render json: {
      message: I18n.t("app.api.messages.create_success",
        authentication_keys: "lawyer specialization"),
      n_l_sp: n_l_sp
    }, status: :ok
  end

  def response_create_failed
    render json: {
      message: I18n.t("app.api.messages.create_failed",
        authentication_keys: "lawyer specialization")
    }, status: :unprocessable_entity
  end

  def get_l_sp
    @l_sp = LawyerSpecialize.find_by id: params[:id]
  end

  def config_lawyer_id
    if current_user.lawyer
      params[:lawyer_specializes][:lawyer_id] = current_user.lawyer.id
    end
  end

  def lawyer_specialize_params
    params.require(:lawyer_specializes).permit LawyerSpecialize::CREATE_PARAMS
  end
end
