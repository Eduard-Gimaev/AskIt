class QuestionDecorator < Draper::Decorator
  delegate_all
  decorates_association :user

  def comments
    object.comments
  end
end
