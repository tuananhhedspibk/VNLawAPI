class Api::V1::PaymentsController < Api::V1::ApplicationController
  before_action :get_room

  authorize_resource

  def index
    @payments = room.payments
    response_payments_idx
  end

  def create
  end

  def update
  end

  private

  attr_reader :room, :payments

  def get_room
    @room = Room.find_by id: params[:id]
    return if room
    render json: {
      message: I18n.t("app.api.messages.not_found",
        authentication_keys: "room")
    }, status: :not_found
  end

  def response_payments_idx
    render json: {
      payments: payments
    }, status: :ok
  end
end
