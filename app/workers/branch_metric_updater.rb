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
    metric = branch.metrics.find_or_create_by(name: metric_params['name'])
    metric.update!(metric_params.except('branch_name')) if metric.present?
    logger.info success_log(metric_params['name'], metric_params['branch_name'])
  end

  def success_log(metric_name, branch)
    "Metric #{metric_name} for branch #{branch} was created"
  end

  def branch
    return @branch if @branch.present?
    @branch = project.branches.find_by_name(@metric_params['branch_name'])
    unless @branch.present?
      ProjectBranchesRetriever.new.perform(@user_id, project.id)
      @branch = project.branches.find_by_name(@metric_params['branch_name'])
    end
    @branch
  end

  def project
    @project ||= Project.find(@project_id)
  end
end
