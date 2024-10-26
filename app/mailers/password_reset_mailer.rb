class PasswordResetMailer < ApplicationMailer
  def password_reset_via_email
    @user = params[:user]
    mail to: @user.email, subject: "#{t('actions.password_reset_instructions')} | Askit"
  end
end
