class BranchManager < SimpleDelegator
  def initialize(branch)
    super
  end

  def metrics_status_success?
    return true unless metrics.present?
    metrics.all? { |m| !m.minimum || m.value.to_f > m.minimum.to_f }
  end
end
