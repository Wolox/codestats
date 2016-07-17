class MetricsController < ApplicationController
  def chart_data
    return render :bad_request if params[:metric_name].nil?
    metrics = branch.metrics.where(name: params[:metric_name]).order('created_at asc')
    authorize metrics.first
    render json: MetricChartDataFormatter.format(metrics)
  end

  private

  def branch
    @branch ||= project.branches.friendly.find(params[:branch_id])
  end

  def project
    @project ||= organization.projects.friendly.find(params[:project_id])
  end

  def organization
    @organization ||= Organization.friendly.find(params[:organization_id])
  end
end
