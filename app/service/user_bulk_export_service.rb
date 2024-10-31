require 'zip'
require 'caxlsx'

class UserBulkExportService < ApplicationService
  attr_reader :initiator, :format

  def initialize(initiator, format)
    @initiator = initiator
    @format = format
  end

  def call
    file = generate_file
    file.rewind if file.respond_to?(:rewind)
    blob = upload_to_active_storage(file)
    blob.key
  ensure
    file.close if file.respond_to?(:close)
  end

  private

  def generate_file
    case format
    when :zip
      User.to_zip # This method from bulkable.rb
    when :xlsx
      User.to_xlsx # This method from bulkable.rb
    else
       raise I18n.t('errors.invalid_format', format: format)
    end
  end

  def upload_to_active_storage(file)
    content_type = case format
                   when :xlsx then 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
                   when :zip then 'application/zip'
                   else 'application/octet-stream'
                   end

    ActiveStorage::Blob.create_and_upload!(
      io: file,
      filename: "users_export_#{Time.now.to_i}.#{format}",
      content_type: content_type
    )
  end
end