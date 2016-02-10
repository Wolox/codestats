class Branch < ActiveRecord::Base
  belongs_to :project
  validates :name, uniqueness: { scope: :project_id }
end
