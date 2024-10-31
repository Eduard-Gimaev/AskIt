class UserBulkImportService < ApplicationService
  attr_reader :blob_key, :service

  def initialize(blob_key)
    @blob_key = blob_key
    @service = ActiveStorage::Blob.service
  end

  def call
    file_uploaded = service.download(blob_key)
    blob = ActiveStorage::Blob.find_by(key: blob_key)
    extname = File.extname(blob.filename.to_s).downcase
    if extname == ".zip"
      process_zip_file(file_uploaded)
    elsif extname == ".xlsx"
      process_xlsx_file(file_uploaded)
    else
      raise "Unsupported file type: #{extname}"
    end
  end
  

  private

  def process_zip_file(file_uploaded)
    begin
      Zip::File.open_buffer(file_uploaded) do |zip|
        zip.each do |entry|
          next unless entry.file? && entry.name.end_with?(".xlsx")
          begin
            puts "Processing entry: #{entry.name}"
            User.import users_from(entry.get_input_stream.read), on_duplicate_key_update: {
                                                                  conflict_target: [ :email ],
                                                                  columns: [ :name, :password_digest ] }
          rescue StandardError => e
            puts "Error processing XLSX file in ZIP entry #{entry.name}: #{e.message}"
          end
        end
      end
    rescue StandardError => e
    end
  end

  def process_xlsx_file(file_uploaded)
    begin
      User.import users_from(file_uploaded), on_duplicate_key_update: {
                                                            conflict_target: [ :email ],
                                                            columns: [ :name, :password_digest ] }
    rescue StandardError => e
    end
  end

  def users_from(file_uploaded)
    begin
      workbook = RubyXL::Parser.parse_buffer(file_uploaded)
      worksheet = workbook[0]
      worksheet.map.with_index do |row, index|
        next if index == 0 # Skip header row
        User.new(name: row[1]&.value,
                email: row[2]&.value,
                password: row[3]&.value,
                password_confirmation: row[3]&.value)
      end.compact # Remove nil values from skipped header row
    rescue StandardError => e
      raise "Error parsing XLSX file: #{e.message}"
    end
  end
end
