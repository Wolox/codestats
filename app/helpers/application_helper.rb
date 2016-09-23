module ApplicationHelper
  def flash_class(level)
    case level
    when 'notice' then 'alert-info'
    when 'success' then 'alert-success'
    when 'error' then 'alert-danger'
    when 'alert' then 'alert-danger'
    end
  end
end
