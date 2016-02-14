class Token
  # Receives an array and generates a digest token
  def self.generate_digest(params)
    Digest::MD5.hexdigest(params.push(Time.current).join(':'))
  end
end
