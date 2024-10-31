module Admin
  class UserMailer < ApplicationMailer
    def bulk_import_email
      @user = params[:user]
      mail(to: @user.email, subject: "Bulk Import Completed")
    end

    def bulk_import_error_email
      @user = params[:user]
      @error_message = params[:error_message]
      mail(to: @user.email, subject: "Bulk Import Failed")
    end

    def bulk_export_email
      @user = params[:user]
      @blob = params[:blob]
      @expires_in = 1.hour
      @download_url = rails_blob_url(@blob, expires_in: @expires_in, disposition: "attachment")
      attachments["users-#{Date.today}.xlsx"] = { mime_type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                                                   content: @blob.download }
      mail(to: @user.email, subject: "Bulk Export Completed")
    end

    def bulk_export_error_email
      @user = params[:user]
      @error_message = params[:error_message]
      mail(to: @user.email, subject: "Bulk Export Failed")
    end
  end
end
