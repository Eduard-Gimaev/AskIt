class SessionsController < ApplicationController
  def new
  end
  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Welcome back, #{current_user.name_or_email}!"
    else
      flash.now[:alert] = 'Email or password is invalid'
      render :new, status: :unauthorized
    end
  end
  def destroy
    user = current_user
    session[:user_id] = nil
    redirect_to root_path, notice: "See you soon, #{user.name_or_email}!"
  end
end