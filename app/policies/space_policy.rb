class SpacePolicy < ApplicationPolicy
  def index?
    user.is_active?
  end

  def show?
    user.is_active?
  end

  def create?
    user.is_active?
  end

  def new?
    user.is_active?
  end

  def update?
    user.is_active? && (user.role == 'admin' || record.creator == user)
  end

  def destroy?
    user.is_active? && (user.role == 'admin' || record.creator == user)
  end

  def join?
    return false unless user.is_active?

    return true if user.role == 'admin'

    user_age_group = user.age_group
    required_age_group = record.required_age_group
    return true if required_age_group.nil?

    case user_age_group&.name
    when 'Adult'
      true
    when 'Teen'
      case required_age_group.name
      when 'Child', 'Teen'
        true
      when 'Adult'
        user.accepted_space_consent_for?(record)
      else
        false
      end
    when 'Child'
      case required_age_group.name
      when 'Child'
        true
      when 'Teen'
        user.accepted_space_consent_for?(record)
      else
        false
      end
    else
      false
    end
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
