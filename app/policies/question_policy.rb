class QuestionPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    !user.guest?
  end

  def update?
    user.present? && (user.admin_role? || user.moderator_role? || user.author?(record))
  end

  def destroy?
    user.present? && (user.admin_role? || user.moderator_role? || user.author?(record))
  end
end
