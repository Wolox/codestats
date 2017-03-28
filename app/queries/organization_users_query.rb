class OrganizationUsersQuery
  attr_reader :relation, :organization

  def initialize(organization, relation = User.all)
    @organization = organization
    @relation = relation
  end

  def fetch
    @relation.joins(:teams).where('teams.organization_id = ?', organization.id).uniq
  end
end
