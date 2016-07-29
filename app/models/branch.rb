class Branch < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  extend FriendlyId
  belongs_to :project
  friendly_id :name, use: :scoped, scope: :project

  has_many :metrics, dependent: :destroy
  validates :name, uniqueness: { scope: :project_id }

  def target_url
    organization_project_branch_url(
      project.organization.friendly_id,
      project.friendly_id,
      friendly_id
    )
  end
end
