class User < ActiveRecord::Base
  validates :name, :session_token, :password_digest, presence: true
  validates :session_token, uniqueness: true
  validates :email, uniqueness: true, allow_nil: true
  validates :password, length: { minimum: 6, allow_nil: true }
  validate :email_presence
  validate :check_if_valid_email

  attr_reader :password

  after_initialize :ensure_session_token

  belongs_to :college,
  class_name: "College",
  inverse_of: :students
  
  has_many :professor_ratings,
    foreign_key: :rater_id,
    inverse_of: :rater,
    dependent: :destroy
    
  has_many :professors,
    through: :professor_ratings,
    source: :professor
    
  has_many :college_ratings,
    foreign_key: :rater_id,
    inverse_of: :rater,
    dependent: :destroy
    
  has_many :up_down_votes,
    foreign_key: :voter_id,
    inverse_of: :voter,
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
  
  def self.find_or_create_by_fb_auth_hash(auth_hash)
    user = User.find_by_uid(auth_hash.uid)
    
    unless user
      user = User.new(uid: auth_hash.uid, password: SecureRandom::urlsafe_base64(16))
      if auth_hash.info.first_name
        user.name = auth_hash.info.first_name
      elsif auth_hash.info.name
        user.name = auth_hash.info.name
      else
        user.name = "Facebook User"
      end
      
      if auth_hash.info.email
        user.email = auth_hash.info.email
      end
      
      user.save!
    end
    
    user
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
    professor_ratings = self.professor_ratings.includes(:professor).includes(:colleges)
 
    professor_ratings + self.college_ratings.includes(:college)
  end

  private
  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end

  def email_presence
    unless self.uid
      unless self.email
        errors.add(:email, "is missing")
      end
    end
  end
  
  def check_if_valid_email
    if self.email
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
end
