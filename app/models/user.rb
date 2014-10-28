class User < ActiveRecord::Base
  validates :name, :session_token, :password_digest, :email, presence: true
  validates :email, :session_token, uniqueness: true
  validate :password, length: { minimum: 6, allow_nil: true }

  attr_reader :password

  after_initialize :ensure_session_token

  def self.find_by_credentials(email, password)
    user = User.find_by_email(email)

    if user
      if !user.is_password?(password)
        return nil
      end
    end

    return user
  end

  def self.generate_session_token
    allSessionTokens = User.select(:session_token)
    p allSessionTokens

    loop do
      token = SecureRandom::urlsafe_base64(16)
      if !allSessionTokens.include(token)
        return token
      end
    end
  end

  def reset_session_token!
    self.session_token = User.generate_session_token
    self.save!
    self.session_token
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
  end

  private
  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end
end
