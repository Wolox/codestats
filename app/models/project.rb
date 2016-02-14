class Project < ActiveRecord::Base
  belongs_to :organization
  has_many :branches, dependent: :destroy
  has_and_belongs_to_many :teams

  def default_branch
    branches.find_by(default: true)
  end

  def generate_metrics_token
    update(metrics_token: Token.generate_digest([organization.id, id, name]))
  end
end
