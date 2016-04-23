class UserOrganizationsQuery
  attr_reader :relation, :user

  def initialize(user, relation = Organization.all)
    @user = user
    @relation = relation
  end

  def fetch
    @relation.joins(:teams).where('teams.id in (?)', user.teams.pluck(:id)).uniq
  end
end
