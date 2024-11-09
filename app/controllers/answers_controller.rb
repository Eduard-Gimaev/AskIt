class AnswersController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :authenticate_user!, except: [ :show ]
  before_action :set_question, only: [ :new, :create, :edit, :update, :show, :destroy ]
  before_action :set_answer, only: [ :show, :edit, :update, :destroy ]

  def new
    @answer = @question.answers.new
    @answer.user = current_user
  end

  def create
    @answer = @question.answers.new(answer_create_params)
    @answers = @question.answers.includes(:user).order(created_at: :desc).page(params[:page]).per(5)
    if @answer.save
      flash.now[:notice] = t("flash.success_create", resource: t("resources.answer"))
      respond_to do |format|
        format.html { redirect_to question_path(@question, anchor: dom_id(@answer)) }
        format.turbo_stream do
          @answer = @answer.decorate
          render turbo_stream: [
            turbo_stream.append("answers", partial: "answers/answer", locals: { answer: @answer }),
            turbo_stream.replace("answer_form", "")
          ]
        end
      end
    else
      flash.now[:alert] = t("flash.failure_create", resource: t("resources.answer"))
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("answer_form", partial: "answers/form", locals: { question: @question, answer: @answer })
          ]
        end
      end
    end
  end

  def edit
  end

  def update
    if @answer.update(answer_update_params)
      flash.now[:notice] = t("flash.success_update", resource: t("resources.answer"))
      respond_to do |format|
        format.html { redirect_to question_path(@answer.question, anchor: dom_id(@answer)) }
        format.turbo_stream do
          @answer = @answer.decorate
        end
      end
    else
      flash.now[:alert] = t("flash.failure_update", resource: t("resources.answer"))
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("answer_form", partial: "answers/form", locals: { question: @question, answer: @answer })
          ]
        end
      end
    end
  end

  def destroy
    @question = @answer.question
    if @answer.destroy
      flash.now[:notice] = t("flash.success_destroy", resource: t("resources.answer"))
      @answers = @question.answers.includes(:user).order(created_at: :desc).page(params[:page]).per(5)
      if @answers.empty? && params[:page].to_i > 1
        params[:page] = params[:page].to_i - 1
        @answers = @question.answers.includes(:user).order(created_at: :desc).page(params[:page]).per(5)
      end
      respond_to do |format|
        format.html { redirect_to question_path(@question), status: :see_other }
        # format.turbo_stream { render turbo_stream: turbo_stream.remove(dom_id(@answer)) } # generates the Turbo Stream response inline, so there's no need for a separate template file
        format.turbo_stream
      end
    else
      flash.now[:alert] = t("flash.failure_destroy", resource: t("resources.answer"))
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
