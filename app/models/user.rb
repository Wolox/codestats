class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  has_and_belongs_to_many :teams

  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first_or_create do |f_user|
      f_user.provider = auth.provider
      f_user.uid = auth.uid
      f_user.email = auth.info.email
      f_user.password = Devise.friendly_token[0, 20]
    end
    user.update_attributes!(auth_token: auth.credentials.token)
    user
  end

  def organizations
    UserOrganizationsQuery.new(self).fetch
  end
end
