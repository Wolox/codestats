class BranchManager < SimpleDelegator
  include Rails.application.routes.url_helpers
  def metrics_status_success?
    return true unless metrics.present?
    BranchLatestMetrics.new(self).find.all? { |m| MetricManager.new(m).status_success? }
  end

  def create_or_update(github_branch, default_branch)
    # A new branch was created in Github with the same name as an already existent one
    if !persisted?
      project.branches.create!(
        name: github_branch.name, github_sha: github_branch.sha, default: default?(default_branch)
      )
    else
      update!(github_sha: github_branch.sha, default: default?(default_branch))
    end
  end

  def target_url
    organization_project_branch_url(
      project.organization.friendly_id,
      project.friendly_id,
      friendly_id
    )
  end

  private

  def default?(github_branch)
    name == github_branch
  end
end
