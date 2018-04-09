class Api::V1::TasksController < Api::V1::ApplicationController
  acts_as_token_authentication_handler_for User

  before_action :get_room, only: [:index, :create]
  before_action :get_task, only: [:update, :destroy]

  def index
    @tasks = room.tasks
    authorize! :read, tasks.first
    response_task_idx
  end

  def create
    params[:tasks][:room_id] = room.id
    @task = Task.new task_create_params
    authorize! :create, task

    task.save ? response_create_success : response_create_failed
  end

  def update
    authorize! :update, task
    return response_update_success if task.update_attributes task_update_params
    response_update_failed
  end

  def destroy
    authorize! :destroy, task
    task.destroy ? response_destroy_success : response_destroy_failed
  end

  private

  attr_reader :tasks, :task, :room

  def response_create_success
    render json: {
      message: I18n.t("app.api.messages.create_success",
        authentication_keys: "task"),
      task: task.as_json(except: :room_id)
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
      task: task.as_json(except: [:room_id, :created_at])
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
      tasks: tasks.as_json(except: [:room_id, :created_at])
    }, status: :ok
  end

  def get_task
    @task = Task.find_by id: params[:id]
    return if task && task.room_id == params[:room_id]
    render json: {
      message: I18n.t("app.api.messages.not_found",
        authentication_keys: "task")
    }, status: :not_found
  end

  def get_room
    @room = Room.find_by id: params[:room_id]
    return if room
    render json: {
      message: I18n.t("app.api.messages.not_found",
        authentication_keys: "room")
    }, status: :not_found
  end

  def task_update_params
    params.require(:tasks).permit Task::UPDATE_PARAMS
  end

  def task_create_params
    params.require(:tasks).permit Task::CREATE_PARAMS
  end
end
