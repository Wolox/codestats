class BranchManager < SimpleDelegator
  def metrics_status_success?
    return true unless metrics.present?
    metrics.all? { |m| !m.minimum || m.value.to_f > m.minimum.to_f }
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

  private

  def default?(github_branch)
    name == github_branch
  end
end
