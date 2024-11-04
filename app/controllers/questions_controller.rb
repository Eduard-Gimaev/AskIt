class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: [ :show, :edit, :update, :destroy ]
  before_action :fetch_tags, only: %i[index new create edit]

  def index
    tag_ids = params[:tag_ids] || []
    @questions = Question.all_by_tags(tag_ids, params[:page], 5)
  end

  def show
    @answers = @question.answers.includes(:user).order(created_at: :desc).page(params[:page]).per(5)
  end

  def new
    @question = Question.new
    @question.user = current_user
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      flash[:notice] = t("flash.success_create", resource: t("resources.question"))
      redirect_to questions_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @question.update(question_params)
      flash.now[:notice] = t("flash.success_update", resource: t("resources.question"))
      redirect_to questions_path
    else
      render :edit
    end
  end

  def destroy
    if @question.destroy
      flash.now[:notice] = t("flash.success_destroy", resource: t("resources.question"))
    else
      flash.now[:alert] = t("flash.failure_destroy", resource: t("resources.question"))
    end
    redirect_to questions_path
  end

  private

  def set_question
     @question = Question.includes(:user).find(params[:id]).decorate
  end

  def question_params
    params.require(:question).permit(:title, :body, tag_ids: [])
  end

  def fetch_tags
    @tags = Tag.all
  end
end
