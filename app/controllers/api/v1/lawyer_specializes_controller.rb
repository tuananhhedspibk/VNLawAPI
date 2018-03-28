class Api::V1::LawyerSpecializesController < Api::V1::ApplicationController
  before_action :find_lawyer
  before_action :correct_user, except: :index
  before_action :get_l_sp, only: :destroy

  authorize_resource

  def index
    response_l_sp_idx
  end

  def create
    @n_l_sp = LawyerSpecialize.new lawyer_specialize_params

    n_l_sp.save ? response_create_success : response_create_failed
  end

  def destroy
    return response_destroy_success if l_sp.destroy
    response_destroy_failed
  end

  private

  attr_reader :lawyer, :l_sp, :n_l_sp

  def response_l_sp_idx
    render json: {
      l_sp: lawyer.specializations
    }, status: :ok
  end

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
      n_l_sp: n_l_sp,
      n_sp: n_l_sp.specialization
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

  def find_lawyer
    @profile = Profile.find_by userName: params[:user_name]
    if !profile
      render json: {
        message: I18n.t("app.api.messages.not_found",
          authentication_keys: "lawyer")
      }, status: :not_found
    else
      @lawyer = Lawyer.find_by id: profile.uid
      if !lawyer
        render json: {
          message: I18n.t("app.api.messages.not_found",
            authentication_keys: "lawyer")
        }, status: :not_found
      else
        return
      end
    end
  end

  def correct_user
    return if lawyer.user.current_user? current_user
    render json: {
      message: I18n.t("app.api.messages.not_authorized")
    }, status: :unauthorized
  end

  def lawyer_specialize_params
    params.require(:lawyer_specialize).permit LawyerSpecialize::CREATE_PARAMS
  end
end
