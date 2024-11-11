class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable!
  before_action :find_comment, only: %i[show edit update destroy]

  def create
    @comment = @commentable.comments.build(comment_params).decorate
    if @comment.save
      flash.now[:notice] = t("flash.success_create", resource: t("resources.comment"))
      respond_to do |format|
        format.html { redirect_to @commentable }
        format.turbo_stream
      end
    else
      flash.now[:alert] = t("flash.failure_create", resource: t("resources.comment"))
      respond_to do |format|
        format.html { render partial: "comments/form", locals: { commentable: @commentable, comment: @comment }, status: :unprocessable_entity }
        format.turbo_stream
      end
    end
  end

  def show
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def edit
    respond_to do |format|
      format.html { render partial: "comments/form", locals: { commentable: @commentable, comment: @comment } }
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("comment_form_#{dom_id(@comment)}", partial: "comments/form", locals: { commentable: @commentable, comment: @comment })
      end
    end
  end

  def update
    if @comment.update(comment_params)
      flash.now[:notice] = t("flash.success_update", resource: t("resources.comment"))
      respond_to do |format|
          format.html { redirect_to @commentable }
          format.turbo_stream
      end
    else
      flash.now[:alert] = t("flash.failure_update", resource: t("resources.comment"))
      respond_to do |format|
        format.html { render partial: "comments/form", locals: { commentable: @commentable, comment: @comment }, status: :unprocessable_entity }
        format.turbo_stream
      end
    end
  end

  def destroy
    @comment.destroy # delete from database
    flash.now[:notice] = t("flash.success_destroy", resource: t("resources.comment"))
    respond_to do |format|
      format.html { redirect_to @commentable }
      format.turbo_stream # remove from the page
    end
  end

  private

  def find_comment
     @comment = @commentable.comments.includes(:user).find(params[:id])
  end

  def set_commentable!
    @commentable = find_commentable
  end

  def find_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end

  def comment_params
    params.require(:comment).permit(:body).merge(user_id: current_user.id)
  end
end
