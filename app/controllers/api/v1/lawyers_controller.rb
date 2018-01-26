class Api::V1::LawyersController < ApplicationController
  def_param_group :lawyer do
    param :name, String, "Name of the lawyer", required: true
    param :rate, Float, "Rate of the lawyer", default: 0
    param :intro, Text, "Introduction of the lawyer", default: ""
    param :cost, Integer, "Cost of the lawyer", default: 0
    param :view_count, Integer, "View of the lawyer", default: 0
  end

  attr_reader :lawyer

  api!
  def show
    @lawyer = Lawyer.find_by id: params[:id]
    render json: lawyer, status: :ok
  end

  api!
  def index
    @lawyers = Lawyer.all
    render json: @lawyers
  end

  api!
  param_group :lawyer
  def create
    @lawyer = Lawyer.new lawyer_params
    if lawyer.save
      render json: lawyer, status: :created
    else
      render json: lawyer.errors, status: :unprocessable_entity
    end
  end

  api!
  param_group :lawyer
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
