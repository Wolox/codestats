class AnalyzeGithubMetricsStatus
  include Sidekiq::Worker
  include Rails.application.routes.url_helpers
  sidekiq_options retry: false
  attr_reader :pull_request, :github_service

  def perform(pull_request_data)
    @pull_request = GithubPullRequest.new(pull_request_data)
    handle_pull_request_status
  end

  def handle_pull_request_status
    project = Project.find_by(github_repo: pull_request.full_name)
    return unless project.present?
    fetch_project_branches(project)
    branch = project.branches.find_by(name: pull_request.branch)
    return unless branch.present?
    change_pull_request_status(project, pull_request_status(branch), branch)
  end

  def change_pull_request_status(project, status, branch)
    github_service = GithubService.new(project.admin_user)
    github_service.create_status(
      pull_request, status[:key],
      context: 'CodeStats',
      target_url: target_url(project, branch),
      description: status[:description]
    )
  end

  def target_url(project, branch)
    organization_project_branch_url(
      project.organization.friendly_id,
      project.friendly_id,
      branch.friendly_id
    )
  end

  def fetch_project_branches(project)
    ProjectBranchesRetriever.new.perform(project.admin_user.id, project.id)
  end

  def pull_request_status(branch)
    BranchManager.new(branch).metrics_status_success? ? success : failure
  end

  def success
    { key: 'success', description: 'All Metrics are OK' }
  end

  def failure
    { key: 'failure', description: 'Some Metrics Failed' }
  end
end
