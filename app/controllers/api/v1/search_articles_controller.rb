class Api::V1::SearchArticlesController < Api::V1::ApplicationController
  before_action :search_articles, only: :index

  def index
    current_page = 1
    @articles_elastic = []
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
            .as_json(only: [:id, :title, :public_day, :article_type, :numerical_symbol,
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
    query = "*"
    if params[:query] && params[:query].length > 0
      query = params[:query]
    end

    if params[:group1] == I18n.t("app.search_box.filter.filter_1")
      @articles = search_match_phrase query
    elsif params[:group1] == I18n.t("app.search_box.filter.filter_2")
      @articles = search_match_word query
    else
      @articles = Article.search query,
        select: [:id, :title, :public_day, :article_type, :numerical_symbol,
          :effect_day, :effect_status],
        order: {public_day: :desc}
    end
  end
    
  def search_match_phrase query
    if params[:group2_1] == I18n.t("app.search_box.filter.filter_3")
      if params[:group2_2] == I18n.t("app.search_box.filter.filter_4")
        @articles = Article.search query,
          select: [:id, :title, :public_day, :article_type, :numerical_symbol,
            :effect_day, :effect_status],
          order: {public_day: :desc}
      else
        @articles = Article.search query,
          select: [:id, :title, :public_day, :article_type, :numerical_symbol,
            :effect_day, :effect_status],
          order: {public_day: :asc}
      end
    else
      if params[:group2_2] == I18n.t("app.search_box.filter.filter_4")
        @articles = Article.search query,
          select: [:id, :title, :public_day,:article_type, :numerical_symbol,
            :effect_day, :effect_status],
          order: {effect_day: :desc}
      else
        @articles = Article.search query,
          select: [:id, :title, :public_day, :article_type, :numerical_symbol,
            :effect_day, :effect_status],
          order: {effect_day: :asc}
      end
    end
    return @articles
  end

  def search_match_word query
    if params[:group2_1] == I18n.t("app.search_box.filter.filter_3")
      if params[:group2_2] == I18n.t("app.search_box.filter.filter_4")
        @articles = Article.search query, operator: "or",
          select: [:id, :title, :public_day, :article_type, :numerical_symbol,
            :effect_day, :effect_status],
          match: :word, order: {public_day: :desc}
      else
        @articles = Article.search query,
          select: [:id, :title, :public_day, :article_type, :numerical_symbol,
            :effect_day, :effect_status],
          match: :word, order: {public_day: :asc}, operator: "or"
      end
    else
      if params[:group2_2] == I18n.t("app.search_box.filter.filter_4")
        @articles = Article.search query, operator: "or",
          select: [:id, :title, :public_day, :article_type, :numerical_symbol,
            :effect_day, :effect_status],
          match: :word, order: {effect_day: :desc}
      else
        @articles = Article.search query, operator: "or",
          select: [:id, :title, :public_day, :article_type, :numerical_symbol,
            :effect_day, :effect_status],
          match: :word, order: {effect_day: :asc}
      end
    end
    return @articles
  end
end
