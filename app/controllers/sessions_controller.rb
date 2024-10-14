class SessionsController < ApplicationController
  def new
  end
  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Welcome to the app, #{User.name}!"
    else
      flash.now[:alert] = 'Email or password is invalid'
      render :new, status: :unauthorized
    end
  end
  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "See you soon, #{User.name}!"
  end
end
