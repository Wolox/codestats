class BranchMetricUpdater
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(user_id, project_id, metric_params)
    @project_id = project_id
    @metric_params = metric_params
    @user = User.find(user_id)
    if branch.present?
      update_metric(metric_params)
    else
      logger.error "branch #{metric_params['branch_name']} was not found"
    end
  end

  private

  def update_metric(metric_params)
    branch.metrics.create!(metric_params.except('branch_name', 'pull_request_number'))
    logger.info success_log(metric_params['name'], branch.name)
  end

  def success_log(metric_name, branch)
    "Metric #{metric_name} for branch #{branch} was created"
  end

  def branch
    return @branch if @branch.present?
    @branch = project.branches.find_by_name(fetch_branch_name)
    @branch = find_branch_in_github unless @branch.present?
    @branch
  end

  def fetch_branch_name
    @metric_params['branch_name'].present? ? @metric_params['branch_name'] : pull_request_branch
  end

  def pull_request_branch
    github_service(@user).get_pull_request_branch(
      project.github_repo, @metric_params['pull_request_number']
    )
  end

  def find_branch_in_github
    logger.info "Branch #{branch.name} does not exist"
    ProjectBranchesRetriever.new.perform(@user.id, project.id)
    project.branches.find_by_name(branch.name)
  end

  def project
    @project ||= Project.find(@project_id)
  end

  def github_service(user)
    @service ||= GithubService.new(user)
  end
end
