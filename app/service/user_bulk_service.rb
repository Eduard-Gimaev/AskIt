class UserBulkService < ApplicationService
  attr_reader :file

  def initialize(file)
    @file = file.tempfile
  end

  def call
  if File.extname(file.path) == '.zip'
    process_zip_file
  elsif File.extname(file.path) == '.xlsx'
    process_xlsx_file(file)
  else
    raise "Unsupported file type"
  end
end

  private

  def process_zip_file
    Zip::File.open_buffer(file.read) do |zip|
      zip.each do |entry|
        next unless entry.file? && entry.name.end_with?('.xlsx')
        begin
          User.import users_from(entry.get_input_stream.read), on_duplicate_key_update: { 
                                                                conflict_target: [:email], 
                                                                columns: [:name, :password_digest] }
        rescue StandardError => e
          puts "Error processing XLSX file in ZIP entry #{entry.name}: #{e.message}"
        end
      end
    end
  end

  def process_xlsx_file(file)
    begin
      User.import users_from(file.read), on_duplicate_key_update: { 
                                                            conflict_target: [:email], 
                                                            columns: [:name, :password_digest] }
    rescue StandardError => e
      puts "Error processing XLSX file: #{e.message}"
    end
  end

  def users_from(file_contents)
    begin
      workbook = RubyXL::Parser.parse_buffer(file_contents)
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