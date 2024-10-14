class UserDecorator < Draper::Decorator
  delegate_all

  def name_or_email
    name.presence || email.split('@').first
  end
end
