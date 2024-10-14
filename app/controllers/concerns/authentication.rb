module Authentication
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    private

    def current_user
      @current_user ||= User.find(session[:user_id]).decorate if session[:user_id]
    end

    def user_signed_in?
      current_user.present?
    end

    helper_method :current_user, :user_signed_in?
  end

  def authenticate_user!
    unless user_signed_in?
      flash.now[:alert] = 'You need to sign in before continuing.'
        render 'sessions/new', status: :unauthorized
    end
  end
end