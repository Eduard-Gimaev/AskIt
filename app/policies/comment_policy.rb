class CommentPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    !user.guest?
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
