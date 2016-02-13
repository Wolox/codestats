class Project < ActiveRecord::Base
  belongs_to :organization
  has_many :branches, dependent: :destroy

  def default_branch
    branches.find_by(default: true)
  end
end
