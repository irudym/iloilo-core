class ActiveQuizSerializer
  # TODO add params https://github.com/Netflix/fast_jsonapi#params
  include FastJsonapi::ObjectSerializer
  attributes :pin, :ended_at, :started, :duration, :title, :is_valid, :description, :max_score
  attributes :connected_users, if: Proc.new { |record, params| 
    params && params[:admin] == true
  }
  attributes :submitted_users, if: Proc.new { |record, params|
    params && params[:admin] == true
  }
  belongs_to :quiz, if: Proc.new { |record, params|
    params && params[:admin] == true
  }
  has_many :questions, if: Proc.new { |record, params | 
    params && params[:show_questions]
  }
end