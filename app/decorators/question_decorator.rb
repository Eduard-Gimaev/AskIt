class QuestionDecorator < Draper::Decorator
  delegate_all
  decorates_association :user
end

