class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  include ErrorHandling
  include Authentication

  before_action :set_locale

  private
  def set_locale
    I18n.locale = session[:locale] || I18n.default_locale 
  end

end
