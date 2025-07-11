class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    user.is_active?
  end

  def show?
    user.is_active?
  end

  def create?
    user.is_active?
  end

  def update?
    user.is_active?
  end

  def destroy?
    user.is_active?
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end
end
