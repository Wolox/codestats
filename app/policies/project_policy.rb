class ProjectPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      UserProjectsQuery.new(user, scope).fetch
    end
  end

  def show?
    UserProjectsQuery.new(user).fetch.include?(record)
  end

  def edit?
    OrganizationPolicy.new(user, record.organization).update?
  end

  def update?
    OrganizationPolicy.new(user, record.organization).update?
  end

  def destroy?
    OrganizationPolicy.new(user, record.organization).destroy?
  end
end
