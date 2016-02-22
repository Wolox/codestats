class UserProjectsQuery
  attr_reader :relation, :user

  def initialize(user, relation = Project.all)
    @user = user
    @relation = relation
  end

  def fetch
    @relation.joins(:organization, :teams).where('teams.id in (?)', user.teams.pluck(:id))
  end
end
