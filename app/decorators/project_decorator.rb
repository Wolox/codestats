class ProjectDecorator < Draper::Decorator
  delegate_all

  def short_github_repo
    object.github_repo.split('/')[1]
  end
end
