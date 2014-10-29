class User < ActiveRecord::Base
  validates :name, :session_token, :password_digest, :college_id, :email, presence: true
  validates :email, :session_token, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true }
  validate :check_email

  attr_reader :password

  after_initialize :ensure_session_token

  belongs_to :college,
    class_name: "College",
    inverse_of: :students
  
  has_many :professor_ratings,
    foreign_key: :rater_id,
    inverse_of: :rater,
    dependent: :destroy

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
    loop do
      token = SecureRandom::urlsafe_base64(16)
      if !User.find_by_session_token(token)
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
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end
  
  def all_ratings
    self.professor_ratings.includes(:professor)
  end

  private
  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end

  def check_email
    email_halves = self.email.split("@")
    if email_halves.length != 2
      errors.add(:email, "is not valid")
    elsif email_halves[0].length == 0
      errors.add(:email, "is not valid")
    elsif email_halves[1].split(".").length != 2
      errors.add(:email, "is not valid")
    elsif email_halves[1].split(".")[0].length == 0
      errors.add(:email, "is not valid")
    elsif email_halves[1].split(".")[1].length == 0
      errors.add(:email, "is not valid")
    end
  end
end
