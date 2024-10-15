module Authentication
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    private

    def authenticate_user!
      unless user_signed_in?
        flash.now[:alert] = "You need to sign in before continuing."
          render "sessions/new", status: :unauthorized
      end
    end

    def current_user
      if session[:user_id]
        @current_user ||= User.find(session[:user_id]).decorate
      elsif cookies.signed[:user_id] && cookies.encrypted[:remember_token]
        user = User.find(cookies.signed[:user_id])
        if user&.authenticated?(cookies.encrypted[:remember_token])
          @current_user = user.decorate
          session[:user_id] = user.id
        end
      end
      # rescue ActiveRecord::RecordNotFound
      # session.delete(:user_id)
      # cookies.delete(:user_id)
      # cookies.delete(:remember_token)
      # @current_user = nil
    end

    def user_signed_in?
      current_user.present?
    end

    def remember_user(user)
      user.remember_me
      cookies.permanent.signed[:user_id] = user.id
      cookies.encrypted.permanent[:remember_token] = user.remember_token
    end

    def forget_user(user)
      user.forget_me
      cookies.delete(:user_id)
      cookies.delete(:remember_token)
      session.delete(:user_id)
      @current_user = nil
    end

    helper_method :current_user, :user_signed_in?
  end
end
