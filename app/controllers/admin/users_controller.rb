class Admin::UsersController < ApplicationController
  before_action :set_user, only: [ :show, :edit, :update, :destroy ]

  def index
    @users = User.order(updated_at: :desc).page(params[:page]).per(5)

    respond_to do |format|
      format.html { render :index }
      format.zip do
        UserBulkExportJob.perform_later(current_user, :zip)
        flash[:notice] = t("flash.export_initiated", resource: t("resources.file"))
        redirect_to admin_users_path
      end
      format.xlsx do
        UserBulkExportJob.perform_later(current_user, :xlsx)
        flash[:notice] = t("flash.export_initiated", resource: t("resources.file"))
        redirect_to admin_users_path
      end
    end
  end

  def new
    @user = User.new
  end

  def create
    if params[:file].present?
      blob_key = create_blob(params[:file])
      begin
        UserBulkImportJob.perform_later(blob_key, current_user)
        flash[:notice] = t("flash.success_upload", resource: t("resources.file"))
      rescue StandardError => e
        flash[:alert] = t("flash.failure_upload", resource: t("resources.file"), error: e.message)
      ensure
        redirect_to admin_users_path
      end
    else
      @user = User.new(user_params)
      if @user.save
        flash.now[:notice] = t("flash.success_create", resource: t("resources.user"))
        redirect_to admin_users_path
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def show
    @user
  end
  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = t("flash.success_update", resource: t("resources.user"))
      redirect_to admin_user_path(@user)
    else
      flash[:alert] = t("flash.failure_update", resource: t("resources.user"))
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      flash[:notice] = t("flash.success_destroy", resource: t("resources.user"))
      redirect_to admin_users_path
    else
      flash[:alert] = t("flash.failure_destroy", resource: t("resources.user"))
      redirect_to admin_users_path
    end
  end

  private

  def create_blob(uploaded_file)
    blob = ActiveStorage::Blob.create_and_upload!(
      io: uploaded_file.tempfile,
      filename: uploaded_file.original_filename,
      content_type: uploaded_file.content_type
    )
    blob.key
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:role, :name, :email,
                                :password, :password_confirmation,
                                :current_password).merge(admin_edit: true)
  end
end
