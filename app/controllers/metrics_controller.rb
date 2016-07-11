class MetricsController < ApplicationController
  def chart_data
    return render :bad_request if params[:metric_name].nil?
    metrics = branch.metrics.where(name: params[:metric_name]).order('created_at asc')
    render json: MetricChartDataFormatter.format(metrics)
  end

  private

  def branch
    @branch ||= Branch.find(params[:branch_id])
  end
end