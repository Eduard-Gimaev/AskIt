class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  include ErrorHandling
  include SessionsHelper
  helper_method :current_user, :user_signed_in?
end
