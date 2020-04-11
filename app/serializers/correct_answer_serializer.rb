# DEPRECATED
class CorrectAnswerSerializer
  include FastJsonapi::ObjectSerializer
  set_id :answer_id
  belongs_to :answer
end