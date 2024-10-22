class UserDecorator < Draper::Decorator
  delegate_all

  def name_or_email
    object.name.presence || object.email.split("@").first
  end
end
