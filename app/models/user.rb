class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :async,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :invitable

  has_and_belongs_to_many :teams

  def organizations
    UserOrganizationsQuery.new(self).fetch
  end
end
