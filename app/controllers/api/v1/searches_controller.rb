class Api::V1::SearchesController < ApplicationController
  before_action :search_articles, only: :index

  def index
    current_page = 1
    @articles_elastic = []
    byebug
    if (@articles.class == Searchkick::Results)
      articlesCount = @articles.total_entries
      @articles.hits.each do |article|
        @articles_elastic << article["_source"]
      end
    else
      articlesCount = @articles.count
    end
    limit_page = (articlesCount) % 8 == 0 ?
      (articlesCount / 8) : (articlesCount / 8 + 1) 
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

    if @articles
      if (@articles.class == Searchkick::Results)
        render json: {
          number_articles: articlesCount,
          current_page: current_page,
          limit_page: limit_page,
          articles: @articles_elastic[(current_page - 1) * 8, 8]
            .as_json
        }, status: :ok
      else
        render json: {
          number_articles: articlesCount,
          current_page: current_page,
          limit_page: limit_page,
          articles: @articles[(current_page - 1) * 8, 8]
            .as_json(only: [:id, :title, :public_day,
              :effect_day, :effect_status])
        }, status: :ok
      end
    else
      render json: {
        articles: null,
      }, status: :not_found
    end
  end

  private

  def search_articles
    if params[:query] && params[:query].length > 0
      if params[:group1] &&
        params[:group1].length > 0
        if params[:group1] == t("app.search_box.filter.filter_1")
          @articles = search_match_phrase
        elsif params[:group1] == t("app.search_box.filter.filter_2")
          @articles = search_match_word
        end
      else
        @articles = search_match_phrase
      end
    else
      if params[:article_type]
        @articles = filter_by_article_type
      elsif params[:agency_issued]
      elsif params[:from_year] and params[:to_year]
        @articles = filter_by_year_issued
      else
        @articles = Article.all
      end
    end
  end

  def search_match_phrase
    if params[:group2_1] == t("app.search_box.filter.filter_4")
      if params[:group2_2] == t("app.search_box.filter.filter_6")
        @articles = Article.search params[:query],
          select: [:id, :title, :public_day,
            :effect_day, :effect_status],
          order: {public_day: :desc}
      else
        @articles = Article.search params[:query],
          select: [:id, :title, :public_day,
            :effect_day, :effect_status],
          order: {public_day: :asc}
      end
    else
      if params[:group2_2] == t("app.search_box.filter.filter_6")
        @articles = Article.search params[:query],
          select: [:id, :title, :public_day,
            :effect_day, :effect_status],
          order: {effect_day: :desc}
      else
        @articles = Article.search params[:query],
          select: [:id, :title, :public_day,
            :effect_day, :effect_status],
          order: {effect_day: :asc}
      end
    end
    return @articles
  end

  def search_match_word
    if params[:group2_1] == t("app.search_box.filter.filter_4")
      if params[:group2_2] == t("app.search_box.filter.filter_6")
        @articles = Article.search params[:query], operator: "or",
          select: [:id, :title, :public_day,
            :effect_day, :effect_status],
          match: :word, order: {public_day: :desc}
      else
        @articles = Article.search params[:query],
          select: [:id, :title, :public_day,
            :effect_day, :effect_status],
          match: :word, order: {public_day: :asc}, operator: "or"
      end
    else
      if params[:group2_2] == t("app.search_box.filter.filter_6")
        @articles = Article.search params[:query], operator: "or",
          select: [:id, :title, :public_day,
            :effect_day, :effect_status],
          match: :word, order: {effect_day: :desc}
      else
        @articles = Article.search params[:query], operator: "or",
          select: [:id, :title, :public_day,
            :effect_day, :effect_status],
          match: :word, order: {effect_day: :asc}
      end
    end
    return @articles
  end

  def filter_by_article_type
    @articles = Article.search where: {article_type: params[:article_type]}
  end

  def filter_by_year_issued
    from_year = Time.parse params[:from_year] + '-1-1'
    to_year = Time.parse params[:to_year] + '-12-31'
    date_range = {}
    date_range[:gte] = from_year
    date_range[:lte] =to_year
    @articles = Article.search where: {public_day: date_range}
  end
end
