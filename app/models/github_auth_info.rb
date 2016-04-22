class GithubAuthInfo
  attr_reader :auth

  delegate :provider, to: :auth
  delegate :uid, to: :auth

  def initialize(auth)
    @auth = auth
  end

  def github_avatar_url
    auth.extra.raw_info.avatar_url
  end

  def github_nickname
    auth.info.nickname
  end

  def auth_token
    auth.credentials.token
  end

  def email
    auth.info.email
  end

  def omniauth_info
    [
      :provider,
      :uid,
      :github_nickname,
      :github_avatar_url
    ].each_with_object({}) { |at, hash| hash[at] = send(at) }
  end
end
