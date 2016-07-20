class ProjectDecorator < Draper::Decorator
  delegate_all

  def short_github_repo
    index = object.github_repo.index('/') + 1
    object.github_repo[index..-1]
  end
end
