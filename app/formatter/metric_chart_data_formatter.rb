class MetricChartDataFormatter
  class << self
    def format(metrics)
      {
        labels: metrics.map(&:created_at).map { |a| a.strftime('%Y/%m/%d %H:%M:%S') },
        values: metrics.map(&:value)
      }
    end
  end
end
