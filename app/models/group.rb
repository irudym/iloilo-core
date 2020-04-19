class Group < ApplicationRecord
  has_many :users
  validates_presence_of :name

  def user_count
    users.count
  end
end
