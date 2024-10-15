class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  include ErrorHandling
  include Authentication
end
