class Team < ActiveRecord::Base
  belongs_to :organization
  has_and_belongs_to_many :projects
  has_and_belongs_to_many :users
  validates :name, :organization, presence: true

  def includes_project?(project)
    project_ids.include?(project.id)
  end
end
