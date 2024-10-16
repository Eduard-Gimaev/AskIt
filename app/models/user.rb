class User < ApplicationRecord
  attr_accessor :current_password, :remember_token

  has_secure_password validations: false

  validates :email, presence: true, uniqueness: true, 'valid_email2/email': true
  validates :password, presence: true, length: { minimum: 4 }, if: :password_required?, allow_blank: true
  validates :password_confirmation, presence: true, if: :password_required?
  validate :password_complexity, if: :password_required?
  validate :current_password_is_correct, if: :current_password_required?, on: :update, if: -> { password.present? }

  before_save { email.downcase! }

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy

  def remember_me
    self.remember_token = SecureRandom.urlsafe_base64
    update_attribute(:remember_token_digest, Digest::SHA1.hexdigest(remember_token.to_s))
  end

  def forget_me
    update_attribute(:remember_token_digest, nil)
  end

  def authenticated?(remember_token)
    return false if remember_token_digest.nil?
    Digest::SHA1.hexdigest(remember_token) == remember_token_digest
  end

  def self.to_xlsx
    attributes = %w[id name email created_at updated_at]

    p = Axlsx::Package.new
    wb = p.workbook
    wb.add_worksheet(name: "Users") do |sheet|
      # Define styles
      header_style = wb.styles.add_style(b: true, alignment: { horizontal: :center },
                                                  border: { style: :thin, color: "000000" })
      even_row_style = wb.styles.add_style(bg_color: "DDDDDD",
                                           border: { style: :thin, color: "000000" })
      odd_row_style = wb.styles.add_style(bg_color: "FFFFFF",
                                          border: { style: :thin, color: "000000" })
      summary_style = wb.styles.add_style(b: true, alignment: { horizontal: :right },
                                            border: { style: :thin, color: "000000" })

      # Add header row with style
      sheet.add_row attributes, style: header_style

      # Freeze the header row
      sheet.sheet_view.pane do |pane|
        pane.top_left_cell = "A2"
        pane.state = :frozen_split
        pane.y_split = 1
      end
      # Add filters to the header row
      sheet.auto_filter = "A1:E1"

      # Add data rows with alternating styles
      all.each_with_index do |user, index|
        row_style = index.even? ? even_row_style : odd_row_style
        row_data = attributes.map do |attr|
        if %w[created_at updated_at].include?(attr)
          user.send(attr).strftime("%Y-%m-%d %H:%M:%S")
        else
          user.send(attr)
        end
      end
      sheet.add_row row_data, style: row_style
      end
      # Add summary row
      total_users = all.count
      sheet.add_row [ "Total Users", total_users ], style: summary_style, height: 20
    end
    p.to_stream.read
  end



  def self.to_zip
    xlsx_data = to_xlsx

    compressed_filestream = Zip::OutputStream.write_buffer do |zos|
      zos.put_next_entry "users-#{Date.today}.xlsx"
      zos.print xlsx_data
    end
    compressed_filestream.rewind
    compressed_filestream.read
  end

  private

  def password_required?
    new_record? || password.present? || password_confirmation.present?
  end

  def current_password_required?
    persisted? && (password.present? || password_confirmation.present?)
  end

  def current_password_is_correct
    unless BCrypt::Password.new(password_digest_was).is_password?(current_password)
      errors.add(:current_password, "is incorrect")
    end
  end

  def password_complexity
    return if password.blank?

    complexity_requirements = {
      "must contain at least one lowercase letter" => /[a-z]/,
      "must contain at least one uppercase letter" => /[A-Z]/,
      "must contain at least one digit" => /\d/,
      "must contain at least one special character" => /[^A-Za-z0-9]/
    }

    complexity_requirements.each do |message, regex|
      unless password.match(regex)
        errors.add(:password, message)
      end
    end
  end
end
