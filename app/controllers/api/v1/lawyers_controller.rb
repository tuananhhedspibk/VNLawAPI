class Api::V1::LawyersController < ApplicationController
  attr_reader :lawyer

  def show
    @lawyer = Lawyer.find_by id: params[:id]
    render json: lawyer, status: :ok
  end

  def index
    @lawyers = Lawyer.all
    render json: @lawyers
  end

  def create
    @lawyer = Lawyer.new lawyer_params
    if lawyer.save
      render json: lawyer, status: :created
    else
      render json: lawyer.errors, status: :unprocessable_entity
    end
  end

  def update
    @lawyer = Lawyer.find_by(id: params[:id])

    if lawyer.update_attributes lawyer_params
      render json: {
        lawyer: lawyer
      }, status: :ok
    else
      render json: lawyer.errors, status: :unprocessable_entity
    end
  end

  private

  def lawyer_params
    params.require(:lawyer).permit(Lawyer::CREATE_PARAMS)
  end
end
