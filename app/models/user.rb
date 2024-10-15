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
    attributes = %w{id name email created_at updated_at}

    p = Axlsx::Package.new
    wb = p.workbook
    wb.add_worksheet(name: "Users") do |sheet|
      sheet.add_row attributes
      all.each do |user|
        sheet.add_row attributes.map { |attr| user.send(attr) }
      end
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
