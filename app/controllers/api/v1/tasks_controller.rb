class Api::V1::TasksController < Api::V1::ApplicationController
  before_action :get_room
  before_action :is_lawyer, except: :index
  before_action :get_task, only: [:update, :destroy]

  authorize_resource

  def index
    response_task_idx
  end

  def create
    @task = Task.new task_create_params

    if task.save ? response_create_success : response_create_failed
  end

  def update
    return response_update_success if task.update_attributes task_update_params
    response_update_failed
  end

  def destroy
    if task.destroy ? response_destroy_success : response_destroy_failed
  end

  private

  attr_reader :tasks, :task, :room

  def get_task
    @task = Task.find_by id: params[:id]
    return if task
    render json: {
      message: I18n.t("app.api.messages.not_found",
        authentication_keys: "task")
    }, status: :not_found
  end

  def is_lawyer
    return if current_user.role == 1
    render json: {
      message: I18n.t("app.api.messages.not_have_permission_create",
        authentication_keys: "task")
    }, status: :unauthorized
  end

  def response_create_success
    render json: {
      message: I18n.t("app.api.messages.create_success",
        authentication_keys: "task"),
      task: task.except(:rid)
    }, status: :ok
  end

  def response_create_failed
    render json: {
      message: I18n.t("app.api.messages.create_falied",
        authentication_keys: "task")
    }, status: :unprocessable_entity
  end

  def response_update_success
    render json: {
      messages: I18n.t("app.api.messages.update_success",
        authentication_keys: "task"),
      task: task
    }, status: :ok
  end

  def response_update_failed
    render json: {
      message: I18n.t("app.api.messages.update_falied",
        authentication_keys: "task")
    }, status: :unprocessable_entity
  end

  def response_destroy_success
    render json: {
      message: I18n.t("app.api.messages.destroy_success",
        authentication_keys: "task")
    }, status: :ok
  end

  def response_destroy_failed
    render json: {
      message: I18n.t("app.api.messages.destroy_falied",
        authentication_keys: "task")
    }, status: :unprocessable_entity
  end

  def response_task_idx
    render json: {
      tasks: room.tasks
    }, status: :ok
  end

  def get_room
    @room = Room.find_by id: params[:id]
    return if room
    render json: {
      message: I18n.t("app.api.messages.not_found",
        authentication_keys: "room")
    }, status: :not_found
  end

  def task_create_params
    params.require(:task).permit Task.CREATE_PARAMS
  end

  def task_update_params
    params.require(:task).permit Task.UPDATE_PARAMS
  end
end
