class SpacePolicy < ApplicationPolicy
  def index?
    user.is_active?
  end

  def show?
    user.is_active?
  end

  def create?
    user.is_active? && (user.role == 'admin' || user.role == 'moderator')
  end

  def new?
    create?
  end

  def edit?
    user.is_active? && (user.role == 'admin' || record.creator == user)
  end

  def update?
    user.is_active? && (user.role == 'admin' || record.creator == user)
  end

  def destroy?
    user.is_active? && (user.role == 'admin' || record.creator == user)
  end


  class Scope < Scope
    def resolve
      if user.is_active?
        scope.where(organization: user.organization)
      else
        scope.none
      end
    end
  end
end
