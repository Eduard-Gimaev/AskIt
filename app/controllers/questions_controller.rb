class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: [ :show, :edit, :update, :destroy ]

  def index
    @questions = Question.all.order(created_at: :desc).page(params[:page]).per(5)
  end

  def show
    @answers = @question.answers.order(created_at: :desc).page(params[:page]).per(3)
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      flash[:notice] = t('flash.success_create', resource: t('resources.question'))
      redirect_to questions_path
    else
      flash[:alert] = t('flash.failure_create', resource: t('resources.question'))
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @question.update(question_params)
      flash[:notice] = t('flash.success_update', resource: t('resources.question'))
      redirect_to questions_path
    else
      flash[:alert] = t('flash.failure_update', resource: t('resources.question'))
      render :edit
    end
  end

  def destroy
    if @question.destroy
      flash[:notice] = t('flash.success_destroy', resource: t('resources.question'))
    else
      flash[:alert] = t('flash.failure_destroy', resource: t('resources.question'))
    end
    redirect_to questions_path
  end

  private

  def set_question
    @question = Question.find(params[:id]).decorate
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
