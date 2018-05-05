class Api::V1::SearchLawyersController < Api::V1::ApplicationController
  before_action :search_lawyers, only: :index

  attr_reader :lawyers

  def index
    current_page = 1
    @lawyers_elastic = []

    if lawyers.class == Searchkick::Results
      lawyersCount = lawyers.total_entries
      lawyers.hits.each do |lawyer|
        profile = Profile.find_by id: lawyer["_id"]
        lawyer_tmp = Lawyer.find_by(user_id: profile.user_id)
        if lawyer_tmp != nil
          @lawyers_elastic << lawyer_tmp
        else
          lawyersCount -= 1
        end
      end
      if params[:sort_by] && params[:sort_by].length > 0
        order_by = ""
        order_by = get_order_by
        if order_by == :rate
          @lawyers_elastic = sort_lawyers_by_rate @lawyers_elastic
        elsif order_by == :price
          @lawyers_elastic.sort_by! &:price
          @lawyers_elastic.reverse!
        end
      else
        @lawyers_elastic = sort_lawyers_by_rate @lawyers_elastic
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
              .as_json(:include => {:specializations => {only: :name},
                :profile => {only: [:displayName, :avatar, :userName]}},
                only: [:intro, :rate, :price])
          }, status: :ok
        else
          render json: {
            number_lawyers: lawyersCount,
            current_page: current_page,
            limit_page: limit_page,
            suggest: false,
            lawyers: lawyers[(current_page - 1) * 6, 6]
              .as_json(:include => {:specializations => {only: :name},
                :profile => {only: [:displayName, :avatar, :userName]}},
                only: [:intro, :rate, :price])
          }, status: :ok
        end
      else
        render json: {
        }, status: :not_found
      end
    else
      if lawyers.class == Searchkick::Results
        if lawyers.suggestions.length > 0
          all_lawyers_name = []
          Lawyer.all.each do |lawyer|
            item = {}
            item[:id] = lawyer.id
            item[:name] = lawyer.profile.displayName
            all_lawyers_name << item
          end
          all_lawyers_name.each do |item|
            item[:name] = removeSignOfVietnameseChar item[:name]
          end
          match_lawyers_id = []
          lawyers.suggestions.each do |lawyer_name|
            all_lawyers_name.each do |item|
              if item[:name] == lawyer_name
                match_lawyers_id.push item[:id]
              end
            end
          end
          @lawyers_suggest = Lawyer.where(id: match_lawyers_id)
            .order(rate: :desc).limit(1)
          if @lawyers_suggest[0]
            render json: {
              number_lawyers: 0,
              suggest: true,
              suggest_name: @lawyers_suggest[0].profile.displayName
            }, status: :ok
          else
            render json: {
            }, status: :not_found
          end
        else
          render json: {
          }, status: :not_found
        end
      end
    end
  end

  def index_names
    @names = []
    Lawyer.all.each do |lawyer|
      names << lawyer.profile.displayName
    end
    render json: {
      names: names
    }, status: :ok
  end

  def top_lawyers
    @top_lawyers = sort_lawyers_by_rate Lawyer.all
    if @top_lawyers
      @top_lawyers_infor = []
      l_ct = 0
      @top_lawyers.each do |lawyer|
        if l_ct < 5
          infor = {}
          infor["fb_id"] = lawyer.user_id
          infor["displayName"] = lawyer.profile.displayName
          infor["avatar"] = lawyer.profile.avatar
          infor["intro"] = lawyer.intro
          infor["price"] = lawyer.price
          infor["userName"] = lawyer.profile.userName
          top_lawyers_infor << infor
          l_ct += 1
        else
          break
        end
      end
      render json: {
        top_lawyers: top_lawyers_infor
      }, status: :ok
    else
      render json: {
      }, status: :not_found
    end
  end

  private

  attr_reader :top_lawyers_names, :top_lawyers_infor, :names

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

  def get_order_by
    order_by = ""
    if params[:sort_by].to_s == I18n.t("app.attorney.sort_by_rate")
      order_by = "rate".to_sym
    elsif params[:sort_by].to_s == I18n.t("app.attorney.sort_by_cost")
      order_by = "price".to_sym
    end
    return order_by
  end

  def sort_lawyers_by_rate lawyers
    lawyer_with_wr = []
    lawyer_without_wr = []
    lawyers.each do |lawyer|
      if lawyer.votes >= 10
        lawyer_with_wr << lawyer
      else
        lawyer_without_wr << lawyer
      end
    end
    lawyer_with_wr = lawyer_with_wr.sort_by(&:wr).reverse
    lawyer_without_wr = lawyer_without_wr.sort_by(&:rate).reverse
    return lawyer_with_wr + lawyer_without_wr
  end

  def search_lawyers
    order_by = ""
    if params[:sort_by] && params[:sort_by].length > 0
      order_by = get_order_by
    end
    if params[:name] && params[:name].length > 0
      @lawyers = Profile.search params[:name], fields: [:displayName],
        suggest: true, match: :phrase
    else
      if params[:sort_by] && order_by == :price
        @lawyers = Lawyer.all.order(order_by => :desc)
      else
        @lawyers = sort_lawyers_by_rate Lawyer.all
      end   
    end
  end
end
