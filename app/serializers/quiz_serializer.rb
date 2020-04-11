class QuizSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :description, :created_at, :updated_at, :duration
  has_many :questions
end
