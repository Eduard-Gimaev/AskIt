class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      remember_user(user) if params[:remember_me] == "1"
      redirect_to root_path, notice: t('flash.success_sign_in', name: current_user.decorate.name_or_email)
    else
      flash.now[:alert] = t('flash.failure', resource: t('resources.session'))
      render :new, status: :unauthorized
    end
  end

  def destroy
    user = current_user
    forget_user current_user
    session[:user_id] = nil
    redirect_to root_path, notice: t('flash.success_sign_out', name: user.decorate.name_or_email)
  end
end