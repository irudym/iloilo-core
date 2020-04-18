class QuizSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :description, :created_at, :updated_at, :duration, :max_score
  has_many :questions
end
