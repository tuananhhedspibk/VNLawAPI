class Api::V1::NewsController < ApplicationController
	def index
		render json: {
			news: News.all.as_json(only: [:id, :public_date, :description]),
			articles: Article.all.as_json(only: [:id, :title]) 
		},status: :ok
	end

	def show
		@new = New.find_by id: params[:id]
		render json: {
			title: @new.title,
			public_date: @new.public_date,
			content: @new.content
		}, status: :ok
	end
end
