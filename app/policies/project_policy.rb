class ProjectPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      UserProjectsQuery.new(user, scope).fetch
    end
  end

  def show?
    UserProjectsQuery.new(user).fetch.include?(record)
  end
end
