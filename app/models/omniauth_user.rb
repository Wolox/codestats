class OmniauthUser
  # Creates a new user if its the first time or returns an existent one
  def self.from_omniauth(auth)
    github_info = GithubAuthInfo.new(auth)
    user = find_or_initialize_omniauth(github_info)
    return user if user.persisted?
    user.update!(
      email: github_info.email,
      auth_token: github_info.auth_token
    )
    user
  end

  def self.omniauth_invitable(auth, invited_user)
    github_info = GithubAuthInfo.new(auth)
    user = find_or_initialize_omniauth(github_info)
    return UserManager.new(user).merge!(invited_user) if user.persisted?
    initialize_github_info(github_info, invited_user)
    invited_user.update!(auth_token: github_info.auth_token)
    invited_user.accept_invitation!
    user
  end

  def self.find_by_invitation_token(token)
    User.find_by_invitation_token(token, true)
  end

  def self.find_or_initialize_omniauth(github_info)
    User.where(provider: github_info.provider, uid: github_info.uid).first_or_initialize do |user|
      initialize_github_info(github_info, user)
      user.password = default_password
    end
  end

  def self.initialize_github_info(github_info, user)
    github_info.omniauth_info.each { |key, value| user.send("#{key}=", value) }
  end

  def self.default_password
    Devise.friendly_token[0, 20]
  end

  private_class_method :find_or_initialize_omniauth, :default_password
end
