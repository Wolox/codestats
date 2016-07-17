class BranchDecorator < Draper::Decorator
  delegate_all

  def show_history?(metric)
    object.metrics.where(name: metric.name).count > 1
  end
end
