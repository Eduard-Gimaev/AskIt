class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  include Pundit
  include ErrorHandling
  include Authentication
  include Authorization


  before_action :set_locale

  helper_method :current_user

  private
  def set_locale
    I18n.locale = session[:locale] || I18n.default_locale
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    # @current_user ||= GuestUser.new
  end
end
