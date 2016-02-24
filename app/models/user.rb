class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :async,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :invitable

  has_and_belongs_to_many :teams

  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first_or_create do |f_user|
      f_user.provider = auth.provider
      f_user.uid = auth.uid
      f_user.email = auth.info.email
      f_user.github_nickname = auth.info.nickname
      f_user.github_avatar_url = auth.extra.raw_info.avatar_url
      f_user.password = Devise.friendly_token[0, 20]
    end
    user.update!(auth_token: auth.credentials.token)
    user
  end

  def self.omniauth_invitable(auth, user)
    user.update!(
      provider: auth.provider, uid: auth.uid,
      github_nickname: auth.info.nickname,
      github_avatar_url: auth.extra.raw_info.avatar_url,
      password: Devise.friendly_token[0, 20],
      auth_token: auth.credentials.token
    )
    user.accept_invitation!
    user
  end

  def organizations
    UserOrganizationsQuery.new(self).fetch
  end
end
