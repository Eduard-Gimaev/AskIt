module ErrorHandling
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
  end

  private

  def not_found(exception)
    logger.warn(exception)
    
    respond_to do |format|
      format.html { render file: Rails.root.join("public/404.html"), status: 404, layout: false }
      format.json { render json: { error: "Not found" }, status: :not_found }
    end
  end
end