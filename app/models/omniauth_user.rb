class OmniauthUser
  def self.from_omniauth(auth)
    user = find_or_create_omniauth(auth)
    user.update!(auth_token: auth.credentials.token)
    user
  end

  def self.omniauth_invitable(auth, user)
    user.update!(
      provider: auth.provider,
      uid: auth.uid,
      github_nickname: auth.info.nickname,
      github_avatar_url: auth.extra.raw_info.avatar_url,
      password: default_password,
      auth_token: auth.credentials.token
    )
    user.accept_invitation!
    user
  end

  def self.find_by_invitation_token(token)
    User.find_by_invitation_token(token, true)
  end

  def self.find_or_create_omniauth(auth)
    User.where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      assign_omniauth_attributes(auth, user)
    end
  end

  def self.assign_omniauth_attributes(auth, user)
    user.provider = auth.provider
    user.uid = auth.uid
    user.email = auth.info.email
    user.github_nickname = auth.info.nickname
    user.github_avatar_url = auth.extra.raw_info.avatar_url
    user.password = default_password
  end

  def self.default_password
    Devise.friendly_token[0, 20]
  end

  private_class_method :find_or_create_omniauth, :assign_omniauth_attributes,
                       :default_password
end
