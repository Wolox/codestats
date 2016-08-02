class Branch < ActiveRecord::Base
  extend FriendlyId
  belongs_to :project
  friendly_id :name, use: :scoped, scope: :project

  has_many :metrics, dependent: :destroy
  validates :name, uniqueness: { scope: :project_id }
end
