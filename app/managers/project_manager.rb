class ProjectManager < SimpleDelegator
  def create(github_repo)
    github_info(github_repo)
    generate_admin_team
    save
    generate_metrics_token
    update_branches
    create_github_webhook
    self
  end

  def update_branches
    return unless github_repo.present?
    ProjectBranchesRetriever.perform_async(organization.admin_user.id, id)
  end

  private

  def create_github_webhook
    return unless github_repo.present?
    ProjectGithubWebhookCreation.perform_async(id)
  end

  def github_info(repo)
    self.name = repo.name
    self.github_repo = repo.full_name
  end

  def generate_admin_team
    self.teams = [organization.admin_team]
  end

  def generate_metrics_token
    update(metrics_token: Token.generate_digest([organization.id, id, name]))
  end
end
