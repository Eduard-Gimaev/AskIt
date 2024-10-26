class UsersController < ApplicationController
  before_action :set_user, only: [ :show, :edit, :update, :destroy ]

  def new
    @user = User.new
  end
  def create
    @user = User.new(user_params)
    if @user.save
      flash.now[:notice] = t("flash.users.create.success")
      redirect_to root_path
    else
      flash.now[:alert] = t("flash.users.create.failure")
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end
  
  def edit
  end

  def update
    if @user.update(user_params)
      flash.now[:notice] = t("flash.users.update.success")
      redirect_to root_path
    else
      flash.now[:alert] = t("flash.users.update.failure")
      render :edit, status: :unprocessable_entity
    end
  end
  def destroy
    if @user.destroy
      flash.now[:notice] = t("flash.users.destroy.success")
      redirect_to users_path
    else
      flash.now[:alert] = t("flash.users.destroy.failure")
      redirect_to @user
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
