class QuizSerializer
  include FastJsonapi::ObjectSerializer
  attributes :first_name, :last_name, :created_at, :email
end