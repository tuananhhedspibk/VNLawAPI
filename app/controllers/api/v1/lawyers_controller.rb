class Api::V1::LawyersController < Api::V1::ApplicationController
  acts_as_token_authentication_handler_for User, only: :update

  before_action :find_profile, :find_lawyer, except: :create
  before_action :correct_user, only: :update

  authorize_resource
  skip_authorize_resource only: :create

  def show
    response_show_succcess
  end

  def create
    @lawyer = Lawyer.new lawyer_create_params

    return response_create_success if lawyer.save
    response_create_failed
  end

  def update
    return response_update_success if lawyer.update_attributes lawyer_update_params
    response_update_failed
  end

  private

  attr_reader :lawyer, :profile

  def find_profile
    @profile = Profile.find_by userName: params[:id]
    return if profile
    render json: {
      messages: I18n.t("app.api.messages.not_found",
        authentication_keys: "lawyer")
    }, status: :not_found
  end

  def find_lawyer
    @lawyer = Lawyer.find_by user_id: profile.user_id
    return if lawyer
    render json: {
      message: I18n.t("app.api.messages.not_found",
        authentication_keys: "lawyer")
    }, status: :not_found
  end

  def response_show_succcess
    render json: {
      lawyer_info: {
        email: lawyer.user.email,
        base_profile: lawyer.user.profile.as_json(
          except: [:id, :user_id, :created_at, :updated_at]),
        lawyer_profile: lawyer.as_json(except:
          [:user_id, :created_at, :updated_at]),
        status: lawyer.user.status
      }
    }, status: :ok
  end

  def response_create_success
    render json: {
      message: I18n.t("app.api.messages.create_success",
        authentication_keys: "lawyer"),
      lawyer: lawyer.as_json(except: :user_id)
    }, status: :ok
  end

  def response_create_failed
    render json: {
      message: I18n.t("app.api.messages.create_failed",
        authentication_keys: "lawyer")
    }, status: :unprocessable_entity
  end

  def response_update_success
    render json: {
      message: I18n.t("app.api.messages.update_success",
        authentication_keys: "lawyer"),
      lawyer_info: {
        base_profile: lawyer.user.profile.as_json(except: [:id, :user_id, :created_at]),
        lawyer_profile: lawyer.as_json(except: [:id, :user_id, :created_at])
      }
    }, status: :ok
  end

  def response_update_failed
    render json: {
      message: I18n.t("app.api.messages.update_failed",
        authentication_keys: "lawyer")
    }, status: :unprocessable_entity
  end

  def correct_user
    return if lawyer.user.current_user? current_user
    render json: {
      message: I18n.t("app.api.messages.not_authorized")
    }, status: :unauthorized
  end

  def lawyer_create_params
    params.require(:lawyers).permit Lawyer::CREATE_PARAMS
  end

  def lawyer_update_params
    params.require(:lawyers).permit Lawyer::UPDATE_PARAMS
  end
end
