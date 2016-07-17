class MetricDecorator < Draper::Decorator
  delegate_all

  def info
    status = MetricManager.new(object).status_success?
    h.content_tag(:div, class: "name #{status_class(status)}") do
      info_content(status)
    end
  end

  private

  def info_content(status)
    h.concat h.content_tag(:i, nil, class: status_fa_icon(status))
    h.concat h.content_tag(:span, "#{object.name} - #{object.value}")
  end

  def status_fa_icon(status)
    status ? 'fa fa-check-circle' : 'fa fa-times-circle'
  end

  def status_class(status)
    status ? 'success' : 'failure'
  end
end
