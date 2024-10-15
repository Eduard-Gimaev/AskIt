class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new create]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  
  def new
    @user = User.new
  end
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = 'User was successfully created.'
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show

  end
  def edit
  end
  def update
    if @user.update(user_params)
      flash[:notice] = 'User was successfully updated.'
      redirect_to root_path
    else
      render :edit, status: :unprocessable_entity
    end

  end
  def destroy
     @user.destroy
    flash[:notice] = 'User was successfully deleted.'
    redirect_to users_path
  end
  
    
  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password)
  end

end
