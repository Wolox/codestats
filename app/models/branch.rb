class Branch < ActiveRecord::Base
  belongs_to :project
  has_many :metrics, dependent: :destroy
  validates :name, uniqueness: { scope: :project_id }
end
