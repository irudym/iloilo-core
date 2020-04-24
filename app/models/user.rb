class User < ApplicationRecord
  has_one :admin
  has_many :quizzes
  has_many :active_quizzes
  belongs_to :group, optional: true
  validates_presence_of :first_name, :last_name, :email, :password_digest
  validates :email,
    format: { with: URI::MailTo::EMAIL_REGEXP },
    presence: true,
    uniqueness: { case_sensitive: false }

  has_secure_password
  
  before_create :downcase_email
  before_update :downcase_email

  def is_admin?
    admin != nil 
  end

  def downcase_email
    self.email.downcase! if self.email
  end

  def generate_password_token!
    begin
      self.reset_password_token = SecureRandom.urlsafe_base64
    end while User.exists?(reset_password_token: self.reset_password_token)
    self.reset_password_token_expires_at = 1.day.from_now
    save!
  end

  def clear_password_token!
    self.reset_password_token = nil
    self.reset_password_token_expires_at = nil
    save!
  end
end
