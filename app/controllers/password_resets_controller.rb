class PasswordResetsController < ApplicationController
  before_action :set_user, only: [ :edit, :update ]

  def create
    user = User.find_by_email(params[:email])
    user.send_password_reset if user
    redirect_to new_session_path, notice: t("actions.password_reset_email_sent")
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to new_session_path, notice: t("actions.password_updated")
    else
      flash.now[:alert] = t("actions.password_reset_failed")
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find_by(password_reset_token: params[:id])
    # unless @user && @user.valid_token_period?
    #   redirect_to new_session_path, alert: t("actions.password_reset_failed")
    # end
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation, :password_reset_token, :email).merge(admin_edit: true)
  end
end
