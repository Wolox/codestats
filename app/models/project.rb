class Project < ActiveRecord::Base
  belongs_to :organization
  has_many :branches, dependent: :destroy

  def default_branch
    branches.find_by(default: true)
  end

  def generate_metrics_token
    update(metrics_token: Token.generate_digest([organization.id, id, name]))
  end
end
