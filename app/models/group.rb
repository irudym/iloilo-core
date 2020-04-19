class Group < ApplicationRecord
  has_many :users

  def user_count
    users.count
  end
end
