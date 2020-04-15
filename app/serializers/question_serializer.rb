class QuestionSerializer
  include FastJsonapi::ObjectSerializer
  attributes :text
  belongs_to :quiz, if: Proc.new { |record, params| 
    params && params[:admin] == true
  } 
  has_many :answers
end
