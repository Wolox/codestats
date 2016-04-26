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
    branch = project.branches.find_by(name: pull_request.branch)
    return unless branch.present?
    @github_service = GithubService.new(project.admin_user)
    change_pull_request_status(pull_request_status(project, branch))
  end

  def change_pull_request_status(_project, status)
    github_service.create_status(
      pull_request, status[:key],
      context: 'CodeStats',
      # TODO: Add host
      # target_url: organization_project_branch_url(project.organization, @project, @branch),
      description: status[:description]
    )
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
