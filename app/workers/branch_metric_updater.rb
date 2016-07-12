class BranchMetricUpdater
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(user_id, project_id, metric_params)
    @project_id = project_id
    @metric_params = metric_params
    @user_id = user_id
    if branch.present?
      update_metric(metric_params)
    else
      logger.error "branch #{metric_params['branch_name']} was not found"
    end
  end

  private

  def update_metric(metric_params)
    branch.metrics.create!(metric_params.except('branch_name'))
    logger.info success_log(metric_params['name'], metric_params['branch_name'])
  end

  def success_log(metric_name, branch)
    "Metric #{metric_name} for branch #{branch} was created"
  end

  def branch
    return @branch if @branch.present?
    @branch = project.branches.find_by_name(@metric_params['branch_name'])
    find_branch_in_github unless @branch.present?
    @branch
  end

  def find_branch_in_github
    logger.info "Branch #{@metric_params['branch_name']} does not exist"
    ProjectBranchesRetriever.new.perform(@user_id, project.id)
    @branch = project.branches.find_by_name(@metric_params['branch_name'])
  end

  def project
    @project ||= Project.find(@project_id)
  end
end
