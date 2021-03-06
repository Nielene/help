class User < ApplicationRecord
  validates :email, :password_digest, :session_token, presence: true
  validates :first_name, :last_name, :zip_code, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }
  validates :email, uniqueness: true
  after_initialize :ensure_session_token
  attr_reader :password

  has_many :reviews
  has_many :photos

  def self.find_by_credentials(email, password)
    user = User.find_by(email: email)
    user && user.is_password?(password) ? user : nil
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64(16)
    self.save!
    self.session_token
  end

  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64(16)
  end

  has_attached_file :image, default_url: "https://s3.amazonaws.com/helpcoreyladovskyprojectdev/users/images/000/000/005/original/default.jpg", styles: { thumb: '100x100', croppable: '600x600>', big: '1000x1000>' }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

end
