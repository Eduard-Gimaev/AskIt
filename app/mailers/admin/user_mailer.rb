module Admin
  class UserMailer < ApplicationMailer
    def bulk_import_email
      @user = params[:user]
      mail(to: @user.email, subject: 'Bulk Import Completed')
    end

    def bulk_import_error_email
      @user = params[:user]
      @error_message = params[:error_message]
      mail(to: @user.email, subject: 'Bulk Import Failed')
    end
  end
end