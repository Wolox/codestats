class Organization < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  validates :name, presence: true
  has_many :projects, dependent: :destroy
  has_many :teams, dependent: :destroy

  def admin_team
    teams.find_by_admin(true)
  end

  def admin_team?(team)
    admin_team == team
  end

  def admin_user
    admin_team&.users&.first
  end

  # Creates the admin team for the organization
  def build_team(user)
    teams.build(name: 'Admins', admin: true, users: [user])
  end
end
