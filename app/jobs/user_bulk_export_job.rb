class UserBulkExportJob < ApplicationJob
  queue_as :default

  def perform(initiator, format)
    blob_key = UserBulkExportService.new(initiator, format).call
    blob = ActiveStorage::Blob.find_by(key: blob_key)
    Admin::UserMailer.with(user: initiator, blob: blob).bulk_export_email.deliver_now
  rescue StandardError => e
    Admin::UserMailer.with(user: initiator, error_message: e.message, error_details: error_details).bulk_export_error_email.deliver_now
  end
end
