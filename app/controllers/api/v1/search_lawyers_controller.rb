class Api::V1::SearchLawyersController < ApplicationController
  before_action :search_lawyers, only: :index

  attr_reader :lawyers

  def index
    current_page = 1
    @lawyers_elastic = []

    if (lawyers.class == Searchkick::Results)
      lawyersCount = lawyers.total_entries
      lawyers.hits.each do |lawyer|
        @lawyers_elastic << Lawyer.includes(:specializations)
          .find_by(id: lawyer["_id"])
      end
    else
      lawyersCount = lawyers.count
    end

    if lawyersCount > 0
      limit_page = lawyersCount % 6 == 0 ? (lawyersCount / 6) :
        (lawyersCount / 6 + 1)
      if params[:page]
        if params[:page].to_i > limit_page
          current_page = limit_page
        elsif params[:page].to_i < 1
          current_page = 1
        else
          current_page = params[:page].to_i
        end
      else
        current_page = 1
      end

      if lawyers
        if lawyers.class == Searchkick::Results
          render json: {
            number_lawyers: lawyersCount,
            current_page: current_page,
            limit_page: limit_page,
            suggest: false,
            lawyers: @lawyers_elastic[(current_page - 1) * 6, 6]
              .as_json(include: :specializations)
          }, status: :ok
        else
          render json: {
            number_lawyers: lawyersCount,
            current_page: current_page,
            limit_page: limit_page,
            suggest: false,
            lawyers: lawyers[(current_page - 1) * 6, 6]
              .as_json(include: :specializations)
          }, status: :ok
        end
      else
        render json: {
          lawyers: null,
        }, status: :not_found
      end
    else
      if lawyers.class == Searchkick::Results
        if lawyers.suggestions.length > 0
          all_lawyers_name = Lawyer.select(:id, :name).all
          all_lawyers_name.each do |item|
            item.name = removeSignOfVietnameseChar item.name
          end
          match_lawyers_id = []
          lawyers.suggestions.each do |lawyer_name|
            all_lawyers_name.each do |item|
              if item.name == lawyer_name
                match_lawyers_id.push item.id
              end
            end
          end
          @lawyers_suggest = Lawyer.where(id: match_lawyers_id)
            .order(rate: :desc).limit(1)
          if @lawyers_suggest[0]
            render json: {
              number_lawyers: 0,
              suggest: true,
              suggest_name: @lawyers_suggest[0].name
            }
          else
          end
        end
      end
    end
  end

  def index_names
    @names = Lawyer.select(:name).all
    if @names
      render json: {
        names: @names
      }, status: :ok
    else
      render json: {
        names: null
      }, status: :not_found
    end
  end

  def top_lawyers
    @top_lawyers = Lawyer.order(rate: :desc).limit(3)
    if @top_lawyers
      render json: {
        top_lawyers: @top_lawyers
      }, status: :ok
    else
      render json: {
        top_lawyers: null
      }, status: :not_found
    end
  end

  private

  def removeSignOfVietnameseChar input
    vietnameseSign = [
      "aAeEoOuUiIdDyY",
      "áàạảãâấầậẩẫăắằặẳẵ",
      "ÁÀẠẢÃÂẤẦẬẨẪĂẮẰẶẲẴ",
      "éèẹẻẽêếềệểễ",
      "ÉÈẸẺẼÊẾỀỆỂỄ",
      "óòọỏõôốồộổỗơớờợởỡ",
      "ÓÒỌỎÕÔỐỒỘỔỖƠỚỜỢỞỠ",
      "úùụủũưứừựửữ",
      "ÚÙỤỦŨƯỨỪỰỬỮ",
      "íìịỉĩ",
      "ÍÌỊỈĨ",
      "đ",
      "Đ",
      "ýỳỵỷỹ",
      "ÝỲỴỶỸ"
    ]
    input = input.downcase
    for i in (1...vietnameseSign.length) do
      for j in (0...vietnameseSign[i].length) do
        input.gsub! vietnameseSign[i][j], vietnameseSign[0][i - 1]
      end
    end
    return input
  end

  def search_lawyers
    order_by = ""
    if params[:sort_by] && params[:sort_by].length > 0
      if params[:sort_by].to_s == t("app.attorney.sort_by_rate")
        order_by = "rate".to_sym
      elsif params[:sort_by].to_s == t("app.attorney.sort_by_cost")
        order_by = "cost".to_sym
      end
    end
    if params[:query] && params[:query].length > 0
      if params[:sort_by] && params[:sort_by].length > 0
        @lawyers = Lawyer.search params[:query], fields: [:name],
          suggest: true, order: {order_by => :desc}, match: :phrase
      else
        @lawyers = Lawyer.search params[:query], fields: [:name],
          suggest: true, order: {rate: :desc}, match: :phrase
      end
    else
      if params[:sort_by] && params[:sort_by].length > 0
        @lawyers = Lawyer.includes(:specializations).all.order(
          order_by => :desc)
      else
        @lawyers = Lawyer.includes(:specializations).all.order(rate: :desc)
      end
    end
  end
end
