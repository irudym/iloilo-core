class QuestionSerializer
  include FastJsonapi::ObjectSerializer
  attributes :text
  belongs_to :quiz
  has_many :answers
  # has_many :right_answers
end
