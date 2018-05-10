class Api::V1::RoomFilesController < Api::V1::ApplicationController
  acts_as_token_authentication_handler_for User

  before_action :get_room, only: :index

  def create
    begin
      @file = RoomFile.new room_files_params
      authorize! :create, file
      file.save
      response_create_file_success
    rescue
      response_create_file_failed
    end
  end

  def index
    authorize! :read, room
    @files = room.room_files
    @files_names = []
    files.each do |file|
      files_names << File.basename(file.file.path)
    end
    response_idx_success
  end

  private

  attr_reader :files, :files_names, :file, :room

  def response_create_file_success
    render json: {
      file_infor: file
    }, status: :ok
  end

  def response_create_file_failed
    render json: {
      message: I18n.t("app.api.messages.create_failed",
        authentication_keys: "room_file")
    }, status: :unprocessable_entity
  end

  def response_idx_success
    render json: {
      list_files: files,
      list_files_names: files_names
    }, status: :ok
  end

  def get_room
    @room = Room.find_by id: params[:room_id]
    return if room
    render json: {
      message: I18n.t("app.api.messages.not_found",
        authentication_keys: "room")
    }, status: :not_found
  end

  def room_files_params
    params.require(:room_files).permit RoomFile::CREATE_PARAMS
  end
end
