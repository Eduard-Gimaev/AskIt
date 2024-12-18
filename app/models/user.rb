class User < ApplicationRecord
  include Recoverable
  include Rememberable
  include Bulkable

  enum role: { user: 0, admin: 1, moderator: 2 }, _suffix: :role

  attr_accessor :current_password, :admin_edit

  has_secure_password validations: false

  validates :role, presence: true
  validates :email, presence: true, uniqueness: true, 'valid_email2/email': true
  validates :password, presence: true, length: { minimum: 4 }, if: :password_required?, allow_blank: true
  validates :password_confirmation, presence: true, if: :password_required?
  validates :password, confirmation: true, if: :password_required?
  validate :password_complexity, if: :password_required?
  validate :current_password_is_correct, if: :current_password_required?, on: :update, if: -> { password.present? && !admin_edit }

  before_save { email.downcase! }

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy

  def author?(resource)
    resource.user == self
  end

  def guest?
    false
  end

  def admin?
    self.admin_role?
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
