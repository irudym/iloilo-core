class AnswerSerializer
  include FastJsonapi::ObjectSerializer
  attributes :text
  attributes :correct, if: Proc.new { |record, params| 
    params && params[:admin] == true
  } 
end
