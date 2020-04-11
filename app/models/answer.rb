class Answer < ApplicationRecord
  belongs_to :question
  has_one :correct_answer
  validates_presence_of :text
end
