class TeamPolicy < ApplicationPolicy
  def create?
    return false unless record.organization.admin_team.present?
    record.organization.admin_team.users.include?(user)
  end

  def update?
    create?
  end

  def destroy?
    create?
  end
end
