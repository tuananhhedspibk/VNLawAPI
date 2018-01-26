require 'api_constraints'

Rails.application.routes.draw do
  apipie
  namespace :api, defaults: { format: :json } do
    scope module: :v1, constraints:
      ApiConstraints.new(version: 1, default: true) do
        get "/search/articles", to: "search_articles#index"
        get "/search/lawyers", to: "search_lawyers#index"
        get "/lawyers/top", to: "search_lawyers#top_lawyers"
        get "/lawyers/names", to: "search_lawyers#index_names"
        resources :articles, only: [:show, :index]
        resources :news, only: [:show, :index]
    end
  end
end
