class BranchPolicy < ApplicationPolicy
  def show?
    ProjectPolicy.new(user, record.project).show?
  end
end
