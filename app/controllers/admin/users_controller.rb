class Admin::UsersController < ApplicationController
  before_action :set_user, only: [ :show, :edit, :update]

  def index
    @users = User.all.order(created_at: :desc).page(params[:page]).per(5)

    respond_to do |format|
      format.html { render :index }
      format.zip { send_data User.to_zip, filename: "users-#{Date.today}.zip" }
      format.xlsx { send_data User.to_xlsx, filename: "users-#{Date.today}.xlsx" }
    end
  end

  def new
    @user = User.new
  end

  def create
    if params[:file].present?
      UserBulkService.call(params[:file])
      flash[:notice] = "File uploaded successfully."
    else
      @user = User.new(user_params)
      if @user.save
        flash[:notice] = "User was successfully created."
      else
        flash[:alert] = "There was an error creating the user."
      end
    end
      redirect_to admin_users_path
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

  # def destroy
  #   @user.destroy
  #   flash[:notice] = "User was successfully deleted."
  #   redirect_to admin_users_path
  # end

  end
  private
  def set_user
    @user = User.find(params[:id])
  end 

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password)
  end

end