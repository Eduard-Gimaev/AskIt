class AnswersController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :authenticate_user!, except: [:show]
  before_action :set_question, only: [ :new, :create ]
  before_action :set_answer, only: [ :show, :edit, :update, :destroy ]

  def new
    @answer = @question.answers.new
    @answer.user = current_user
  end

  def create
    @answer = @question.answers.new(answer_create_params)

    if @answer.save
       flash[:notice] = t('flash.success_create', resource: t('resources.answer'))
      redirect_to question_path(@question, anchor: dom_id(@answer))
    else
      flash[:alert] = t('flash.failure_create', resource: t('resources.answer'))
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @answer.update(answer_update_params)
      flash[:notice] = t('flash.success_update', resource: t('resources.answer'))
      redirect_to question_path(@answer.question, anchor: dom_id(@answer))
    else
      flash[:alert] = t('flash.failure_update', resource: t('resources.answer'))
      render :edit
    end
  end

  def destroy
    @question = @answer.question
    if @answer.destroy
      flash[:notice] = t('flash.success_destroy', resource: t('resources.answer'))
      redirect_to question_path(@question)
    else
      flash[:alert] = t('flash.failure_destroy', resource: t('resources.answer'))
      redirect_to question_path(@question)
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id]).decorate
  end

  def set_answer
    @answer = Answer.find(params[:id]).decorate
  end

  def answer_create_params
    params.require(:answer).permit(:body).merge(user_id: current_user.id)
  end
  def answer_update_params
    params.require(:answer).permit(:body)
  end

end
