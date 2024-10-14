class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  allow_browser versions: :modern
  include ErrorHandling
  include Authentication


end
