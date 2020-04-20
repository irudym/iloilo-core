class User < ApplicationRecord
  has_one :admin
  has_many :quizzes
  has_many :active_quizzes
  belongs_to :group, optional: true
  validates_presence_of :first_name, :last_name, :email, :password_digest
  has_secure_password
  before_create :downcase_email

  def is_admin?
    admin != nil 
  end

  def downcase_email
    self.email.downcase!
  end
end
