class UserBulkImportJob < ApplicationJob
  queue_as :default

  def perform(blob_key, initiator)
    UserBulkImportService.new(blob_key).call
  rescue StandardError => e
      Admin::UserMailer.with(user: initiator, error_message: e.message).bulk_import_error_email.deliver_now
  else
      Admin::UserMailer.with(user: initiator).bulk_import_email.deliver_now
  end
end