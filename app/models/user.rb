class User < ActiveRecord::Base
  extend FriendlyId
  belongs_to :organization
  friendly_id :github_nickname, use: :slugged
  devise :database_authenticatable, :registerable, :async,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :invitable

  has_and_belongs_to_many :teams

  def organizations
    UserOrganizationsQuery.new(self).fetch
  end
end
