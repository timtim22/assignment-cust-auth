class ContentPolicy < ApplicationPolicy
  def index?
    user.present? && member_of_organization?
  end

  def show?
    user.present? && member_of_organization? && age_appropriate?
  end

  def create?
    user.present? && member_of_organization? && user.has_full_access?
  end

  def new?
    create?
  end

  def update?
    user.present? && (owner? || admin_of_organization?)
  end

  def edit?
    update?
  end

  def destroy?
    user.present? && (owner? || admin_of_organization?)
  end

  private

  def member_of_organization?
    return false unless user && record&.organization
    record.organization.user_member?(user)
  end

  def admin_of_organization?
    return false unless user && record&.organization
    record.organization.user_admin?(user)
  end

  def owner?
    return false unless user && record
    record.user == user
  end

  def age_appropriate?
    return true unless record
    record.appropriate_for_user?(user)
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.none unless user

      # Only show content from organizations the user is a member of
      organization_ids = user.organizations.pluck(:id)
      age_appropriate_content = scope.joins(:organization)
                                    .where(organization_id: organization_ids)
                                    .for_age_group(user.age_group)
      
      age_appropriate_content
    end
  end
end
