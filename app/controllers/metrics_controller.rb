class MetricsController < ApplicationController
  def chart_data
    return render :bad_request if params[:metric_name].nil?
    metrics = branch.metrics.where(name: params[:metric_name]).order('created_at asc')
    render json: format_data(metrics)
  end

  private

  def format_data(metrics)
    {
      labels: metrics.map(&:created_at).map { |a| a.strftime('%Y/%m/%d %H:%M:%S') },
      values: metrics.map(&:value)
    }
  end

  def branch
    Branch.find(params[:branch_id])
  end
end
