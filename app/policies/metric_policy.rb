class MetricPolicy < ApplicationPolicy
  def chart_data?
    BranchPolicy.new(user, record.branch).show?
  end
end
