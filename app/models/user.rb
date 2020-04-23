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
end
