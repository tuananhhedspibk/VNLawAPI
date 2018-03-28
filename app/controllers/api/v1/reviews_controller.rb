class Api::V1::ReviewsController < Api::V1::ApplicationController
  acts_as_token_authentication_handler_for User, except: :index

  before_action :find_user, :correct_user, except: :index
  before_action :find_lawyer, only: :index
  before_action :get_review, only: :update

  authorize_resource

  def index
    response_all_reviews
  end

  def create
    @review = Review.new review_create_params

    review.save ? response_create_success : response_create_failed
  end

  def update
    return response_update_success if review.update_attributes review_update_params
    response_update_failed
  end

  private

  attr_reader :reviews, :profile, :lawyer, :user, :review

  def get_review
    @review = Review.find_by id: params[:id]
  end

  def response_update_success
    render json: {
      message: I18n.t("app.api.messages.update_success",
        authentication_keys: "review"),
      review: review.as_json(except: [:user_id, :lawyer_id,
        :created_at])
    }, status: :ok
  end

  def response_update_failed
    render json: {
      message: I18n.t("app.api.messages.update_failed",
        authentication_keys: "review")
    }, status: :unprocessable_entity
  end

  def response_create_success
    render json: {
      message: I18n.t("app.api.messages.create_success",
        authentication_keys: "review"),
      review: review.as_json(except: [:user_id, :lawyer_id])
    }, status: :ok
  end

  def response_create_failed
    render json: {
      message: I18n.t("app.api.messages.create_failed",
        authentication_keys: "review")
    }, status: :unprocessable_entity
  end

  def response_all_reviews
    render json: {
      reviews: lawyer.reviews.as_json(except:
        [:user_id, :lawyer_id, :created_at])
    }, status: :ok
  end

  def find_user
    @profile = Profile.find_by userName: params[:user_name]
    if !profile
      render json: {
        message: I18n.t("app.api.messages.not_found",
          authentication_keys: "users")
      }, status: :not_found
    else
      @user = User.find_by id: profile.uid
      if !user || user.role == 1
        render json: {
          messages: I18n.t("app.api.messages.not_have_permission_create",
            authentication_keys: "review")
        }, status: :unauthorized
      else
        return
      end
    end
  end

  def find_lawyer
    @profile = Profile.find_by userName: params[:lawyer_id]
    if !profile
      render json: {
        message: I18n.t("app.api.messages.not_found",
          authentication_keys: "lawyers")
      }, status: :not_found
    else
      @lawyer = Lawyer.find_by user_id: profile.user_id
      if !lawyer
        render json: {
          message: I18n.t("app.api.messages.not_found",
            authentication_keys: "lawyers")
        }, status: :not_found
      else
        return
      end
    end
  end

  def review_update_params
    params.require(:review).permit Review::UPDATE_PARAMS
  end

  def review_create_params
    params.require(:review).permit Review::CREATE_PARAMS
  end
end
