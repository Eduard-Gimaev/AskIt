class LocalesController < ApplicationController

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
    session[:locale] = I18n.locale
    redirect_back(fallback_location: root_path) 
  end
end