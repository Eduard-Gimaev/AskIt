class Admin::UsersController < ApplicationController
  before_action :set_user, only: [ :show, :edit, :update]

  def index
    @users = User.all.order(created_at: :desc).page(params[:page]).per(5)

    respond_to do |format|
      format.html { render :index }
      format.zip { send_data User.to_zip, filename: "users-#{Date.today}.zip" }
    end
  end

  def show
    @user 
  end
  def edit

  end
  def update
    if @user.update(user_params)
      flash[:notice] = "User was successfully updated."
      redirect_to root_path
    else
      render :edit, status: :unprocessable_entity
  end

  def destroy
  end

  end
  private
  def set_user
    @user = User.find(params[:id])
  end 

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password)
  end

end