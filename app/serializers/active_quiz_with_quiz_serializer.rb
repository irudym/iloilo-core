class ActiveQuizSerializerWithQuiz
  include FastJsonapi::ObjectSerializer
  attributes :pin, :ended_at, :started, :duration, :title
end