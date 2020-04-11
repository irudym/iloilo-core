class User < ApplicationRecord
  has_one :admin
  has_many :quizzes
  has_many :active_quizzes
  validates_presence_of :first_name, :last_name, :email, :password_digest
  has_secure_password

  def is_admin?
    admin != nil 
  end
end
