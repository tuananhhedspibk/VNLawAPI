require "api_constraints"

Rails.application.routes.draw do
  devise_for :users

  namespace :api, defaults: { format: :json } do
    scope module: :v1, constraints:
      ApiConstraints.new(version: 1, default: true) do
        devise_scope :user do
          post "/signup", to: "registrations#create"
          post "/login", to: "sessions#create"
          delete "/logout", to: "sessions#destroy"

          get "/search/lawyers", to: "search_lawyers#index"
          get "/search/top_lawyers", to: "search_lawyers#top_lawyers"
          get "/search/lawyers_names", to: "search_lawyers#index_names"
          get "/search/articles", to: "search_articles#index"          

          post "/deposits", to: "deposits#create"
          get "/checkdeposit", to: "checkdeposit#show"
          get "/money_account", to: "money_accounts#show"
          patch "/money_account", to: "money_accounts#update"

          resources :articles, only: [:show, :index],
            :constraints => { :id => /[0-9A-Za-z\-\.\_]+/ }
          resources :users, only: [:show, :update],
            :constraints => { :id => /[0-9A-Za-z\-\.\_]+/ } do
              resources :deposit_histories, only: [:index, :create]
          end
          resources :lawyers, only: [:create, :show, :update],
            :constraints => { :id => /[0-9A-Za-z\-\.\_]+/ } do
            resources :reviews, only: :index
            resources :tasks, only: :index
          end
          resources :lawyer_specializes, only: [:destroy, :create]
          resources :reviews, only: [:create, :update]
          resources :rooms, only: [:show, :index, :create, :update] do
            resources :tasks, only: [:index, :create, :update, :destroy]
            resources :room_files, only: :index
          end
          resources :room_files, only: :create
        end
    end
  end
end

# index, show, create, new , update, edit, destroy
