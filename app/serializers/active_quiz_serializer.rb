class ActiveQuizSerializer
  # TODO add params https://github.com/Netflix/fast_jsonapi#params
  include FastJsonapi::ObjectSerializer
  attributes :pin, :ended_at, :started, :duration, :title
  attributes :connected_users, if: Proc.new { |record, params| 
    params && params[:admin] == true
  }
  belongs_to :quiz, if: Proc.new { |record, params|
    !(params && params[:hide_quiz] == true)
  }
end