module Authorization
  extend ActiveSupport::Concern

  included do
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    private
    include Pundit

    def user_not_authorized
      flash[:alert] = t("flash.authorization_required")
      redirect_to(request.referrer || root_path)
    end
  end
end
