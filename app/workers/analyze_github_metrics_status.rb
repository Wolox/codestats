class AnalyzeGithubMetricsStatus
  include Sidekiq::Worker
  sidekiq_options retry: false
  attr_reader :pull_request, :github_service, :project, :branch

  def perform(pull_request_data)
    @pull_request = GithubPullRequest.new(pull_request_data)
    handle_pull_request_status
    return unless project.present? && branch.present?
    GithubIssueCommenter.new.perform(project.id, branch.id, pull_request_data)
  end

  def handle_pull_request_status
    fetch_project
    fetch_branch if project.present?
    change_pull_request_status(pull_request_status) if branch.present?
  end

  def fetch_project
    @project = Project.find_by(github_repo: pull_request.full_name)
    fetch_project_branches if project.present?
  end

  def fetch_branch
    @branch = project.branches.find_by(name: pull_request.branch)
  end

  def change_pull_request_status(status)
    return unless branch.present?
    github_service.create_status(
      pull_request, status[:key],
      context: 'CodeStats',
      target_url: BranchManager.new(branch).target_url,
      description: status[:description]
    )
  end

  def github_service
    @github_service ||= GithubService.new(project.admin_user)
  end

  def fetch_project_branches
    ProjectBranchesRetriever.new.perform(project.admin_user.id, project.id)
  end

  def pull_request_status
    BranchManager.new(branch).metrics_status_success? ? success : failure
  end

  def success
    { key: 'success', description: 'All Metrics are OK' }
  end

  def failure
    { key: 'failure', description: 'Some Metrics Failed' }
  end
end
