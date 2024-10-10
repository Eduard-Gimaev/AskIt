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
      redirect_to questions_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    @question.update(question_params) ? redirect_to(questions_path) : render(:edit)
  end

  def destroy
    if @question.destroy
      redirect_to questions_path
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end 

  def set_question
    @question = Question.find(params[:id])
  end
end
