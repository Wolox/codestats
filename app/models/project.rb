class Project < ActiveRecord::Base
  extend FriendlyId
  belongs_to :organization
  friendly_id :name, use: :scoped, scope: :organization

  has_many :branches, dependent: :destroy
  has_and_belongs_to_many :teams

  delegate :admin_user, to: :organization

  accepts_nested_attributes_for :teams

  def default_branch
    branches.find_by(default: true)
  end

  def default_branch_metrics
    BranchLatestMetrics.new(default_branch).find
  end

  def generate_metrics_token
    update(metrics_token: Token.generate_digest([organization.id, id, name]))
  end
end
