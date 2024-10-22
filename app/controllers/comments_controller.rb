class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable!
  before_action :find_comment, only: :destroy

  def create
    @comment = @commentable.comments.build(comment_params)
    if @comment.save
      redirect_to @commentable, notice: t('flash.success_create', resource: t('resources.comment'))
    else
      flash.now[:alert] = t('flash.failure_create', resource: t('resources.comment'))
      render partial: 'comments/form', locals: { commentable: @commentable, comment: @comment }
    end
  end

  def destroy
    @comment.destroy
    redirect_to @commentable, notice: t('flash.success_destroy', resource: t('resources.comment'))
  end

  private

  def find_comment
     @comment = @commentable.comments.includes(:user).find(params[:id])
  end

  def set_commentable!
    klass = [Question, Answer].detect { |c| params["#{c.name.underscore}_id"] }
    raise ActionController::RoutingError, 'Not Found' unless klass
    @commentable = klass.includes(:user).find(params["#{klass.name.underscore}_id"])
  end

  def comment_params
    params.require(:comment).permit(:body).merge(user_id: current_user.id)
  end
end