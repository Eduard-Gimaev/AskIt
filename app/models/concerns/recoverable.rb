module Recoverable
  extend ActiveSupport::Concern

  included do
    before_update :clear_password_reset_token, if: :password_digest_changed?
    def send_password_reset
      generate_token
      PasswordResetMailer.with(user: self).password_reset_via_email.deliver_later
    end

    def valid_token_period?
      password_reset_sent_at && password_reset_sent_at <= 1.minutes.ago
    end

    def clear_password_reset_token
      self.update_columns(password_reset_token: nil, password_reset_sent_at: nil)
    end

    private
    def generate_token
      update_columns(password_reset_token: SecureRandom.urlsafe_base64,
              password_reset_sent_at: Time.zone.now)
    end
  end
end
