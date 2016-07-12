class MetricManager < SimpleDelegator
  def status_success?
    !minimum || value.to_f > minimum.to_f
  end
end
