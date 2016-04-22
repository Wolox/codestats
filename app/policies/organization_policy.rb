class OrganizationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      UserOrganizationsQuery.new(user, scope).fetch
    end
  end

  def create?
    true
  end

  def update?
    return false unless record.admin_team.present?
    record.admin_team.users.include?(user)
  end

  def destroy?
    update?
  end
end
