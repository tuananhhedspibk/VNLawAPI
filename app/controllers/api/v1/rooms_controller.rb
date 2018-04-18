class Api::V1::RoomsController < Api::V1::ApplicationController
  acts_as_token_authentication_handler_for User

  before_action :find_room, only: :update
  before_action :load_object, only: [:index, :create]
  before_action :check_user_id, only: :create

  def index
    @rooms = user.rooms
    authorize! :read, rooms.first

    response_rooms_idx
  end

  def create
    begin
      params[:rooms][:lawyer_id] = user.id
      @room = Room.new room_create_params
      authorize! :create, room
      room.save
      response_create_success
    rescue
      response_create_failed
    end
  end

  def update
    authorize! :update, room
    return response_update_success if room.update_attributes room_update_params
    response_update_failed
  end

  private

  attr_reader :room, :rooms, :user

  def response_rooms_idx
    data = []
    rooms.each do |room|
      lawyer = {
        id: room.lawyer.id,
        uid: room.lawyer.user_id,
        status: room.lawyer.user.status,
        displayName: room.lawyer.profile.displayName,
        avatar: room.lawyer.profile.avatar,
        userName: room.lawyer.profile.userName
      }
      user = {
        uid: room.user.id,
        status: room.user.status,
        displayName: room.user.profile.displayName,
        avatar: room.user.profile.avatar,
        userName: room.user.profile.userName
      }
      obj = {
        id: room.id,
        lawyer: lawyer,
        user: user,
        description: room.description
      }
      data << obj
    end
    render json: {
      rooms: data
    }, status: :ok
  end

  def response_update_success
    render json: {
      message: I18n.t("app.api.messages.update_success",
        authentication_keys: "room"),
      room: room.as_json(except: [:id, :created_at])
    }, status: :ok
  end

  def response_update_failed
    render json: {
      message: I18n.t("app.api.messages.update_failed",
        authentication_keys: "room")
    }, status: :unprocessable_entity
  end

  def response_create_success
    render json: {
      message: I18n.t("app.api.messages.create_success",
        authentication_keys: "room"),
      room: room.as_json(except: [:user_id, :lawyer_id],
        :include => {
          :user => {
            :only => :id,
            :include => {
              :profile => {only: :userName}
            }
          },
          :lawyer => {
            :only => :id,
            :include => {
              :profile => {only: :userName}
            }
          }
        })
    }, status: :ok
  end

  def response_create_failed
    render json: {
      message: I18n.t("app.api.messages.create_failed",
        authentication_keys: "room")
    }, status: :unprocessable_entity
  end

  def find_room
    @room = Room.find_by id: params[:id]
    return if room
    render json: {
      message: I18n.t("app.api.messages.not_found",
        authentication_keys: "room")
    }, status: :not_found
  end

  def load_object
    if current_user.role.name == "Lawyer"
      @user = Lawyer.find_by user_id: current_user.id
    else
      @user = current_user
    end
  end

  def check_user_id
    @us = User.find_by id: params[:rooms][:user_id]
    return if @us && @us.role.name == "User"
    render json: {
      message: I18n.t("app.api.messages.not_found",
        authentication_keys: "User")
    }, status: :not_found
  end

  def room_update_params
    params.require(:rooms).permit Room::UPDATE_PARAMS
  end

  def room_create_params
    params.require(:rooms).permit Room::CREATE_PARAMS
  end
end
