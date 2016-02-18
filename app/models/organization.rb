class Organization < ActiveRecord::Base
  validates :name, presence: true
  has_many :projects, dependent: :destroy
  has_many :teams, dependent: :destroy

  def admin_team
    teams.find_by_admin(true)
  end
end
