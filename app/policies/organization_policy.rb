class OrganizationPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    user.present?
  end

  def create?
    user.present? && user.has_full_access?
  end

  def new?
    create?
  end

  def update?
    user.present? && admin?
  end

  def edit?
    update?
  end

  def destroy?
    user.present? && admin?
  end

  def join?
    user.present? && 
    user.has_full_access? && 
    !member? && 
    record.available_for_user?(user)
  end

  def leave?
    user.present? && member?
  end

  def manage_members?
    user.present? && admin?
  end

  def create_content?
    user.present? && (admin? || member?)
  end

  def manage_content?
    user.present? && admin?
  end

  private

  def member?
    return false unless user && record
    record.user_member?(user)
  end

  def admin?
    return false unless user && record
    record.user_admin?(user)
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.present?
        scope.all
      else
        scope.none
      end
    end
  end
end
