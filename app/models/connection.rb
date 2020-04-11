class Connection < ApplicationRecord
  belongs_to :user
  belongs_to :active_quiz

  def self.connected_users(active_quiz)
    users = self.where('created_at > ? and active_quiz_id = ?', DateTime.now - 5.minutes, active_quiz.id).inject([]) do |acc, con|
      unless acc.include?(con.user_id) 
        acc << con.user_id
      end
      acc
    end
    User.select([:first_name, :last_name]).where(id: users).map do |user|
      "#{user.first_name} #{user.last_name}"
    end
  end
end
