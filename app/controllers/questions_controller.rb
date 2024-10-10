class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      flash[:notice] = 'Question was successfully created.'
      redirect_to questions_path
    else
      flash.now[:alert] = 'There was an error creating the question.'
      render :new
    end
  end

  def edit
  end

  def update
    if @question.update(question_params)
      flash[:notice] = 'Question was successfully updated.'
      redirect_to questions_path
    else
      flash.now[:alert] = 'There was an error updating the question.'
      render :edit
    end
  end

  def destroy
    if @question.destroy
      flash[:notice] = 'Question was successfully deleted.'
      redirect_to questions_path
    else
      flash[:alert] = 'There was an error deleting the question.'
      redirect_to questions_path
    end
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end