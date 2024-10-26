module Rememberable
  extend ActiveSupport::Concern

  included do
    attr_accessor :remember_token

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
  end
end
