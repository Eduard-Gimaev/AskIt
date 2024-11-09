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
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@comment, partial: "comments/comment", locals: { comment: @comment }) }
      end
    end
  end

  def show
  end

  def edit
    render partial: "comments/form", locals: { commentable: @commentable, comment: @comment }
  end

  def update
   @comment.update(comment_params)
   falsh.now[:notice] = t("flash.success_update", resource: t("resources.comment"))
   respond_to do |format|
      format.html { redirect_to @commentable }
      format.turbo_stream { render turbo_stream: turbo_stream.replace(@comment, partial: "comments/comment", locals: { comment: @comment }) }
   end

  end

  def destroy
    @comment.destroy
    flash.now[:notice] = t("flash.success_destroy", resource: t("resources.comment"))
    respond_to do |format|
      format.html { redirect_to @commentable }
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@comment) }
    end
  end

  private

  def find_comment
     @comment = @commentable.comments.includes(:user).find(params[:id])
  end

  def set_commentable!
    klass = [ Question, Answer ].detect { |c| params["#{c.name.underscore}_id"] }
    raise ActionController::RoutingError, "Not Found" unless klass
    @commentable = klass.includes(:user).find(params["#{klass.name.underscore}_id"])
  end

  def comment_params
    params.require(:comment).permit(:body).merge(user_id: current_user.id)
  end
end
