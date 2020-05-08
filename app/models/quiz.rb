class Quiz < ApplicationRecord
  has_many :questions
  belongs_to :user, optional: true
  validates_presence_of :title


  def destroy_with_questions
    self.questions.each do |question|
      question.destroy_with_answers
    end
    self.destroy
  end

  def create_questions(object)
    if object[:questions]
      object[:questions][:data].map do |question|
        if question[:type].eql?("question")
          qst = Question.create!(text: question[:attributes][:text], quiz: self)
          qst.create_answers question[:relationships] if question[:relationships]
        end
      end 
    end
  end

  def update_questions(object) 
    if object[:questions]
      questionids = self.question_ids
      provided_ids = object[:questions][:data].inject([]) do |acc, question|
        if question[:type].eql?("question")
          qst = nil
          if question[:id]
            begin 
              qst = Question.find(question[:id].to_i)
              qst.update!(text: question[:attributes][:text]) if qst # obsolete code as find will raise an exception in case no question
              qst.update_answers(question[:relationships]) if qst
              acc << question[:id].to_i
            rescue
              qst = nil
            end
          end
          if !qst
            newQuestion = Question.create!(quiz: self, text: question[:attributes][:text])
            newQuestion.create_answers(question[:relationships])
          end
        end
        acc
      end
      
      # delete unused question
      questionids.map do |id|
        unless provided_ids.include?(id) 
          self.questions.find(id).destroy_with_answers
        end 
      end
    end
  end

  # provided_quesitons  - an array with questions objects 
  def evaluate(provided_questions)
    user_right_answers = provided_questions.inject({}) do |acc, question|
      if question[:relationships] && question[:relationships][:answers] && question[:relationships][:answers][:data]
        acc[question[:id].to_i] = question[:relationships][:answers][:data].inject([]) do |accumul, answer|
          accumul << answer[:id].to_i if answer[:attributes][:correct]
          accumul
        end
      end
      acc
    end

    questions_rigth_answers = Answer.where(question: self.questions, correct: true).inject({}) do |acc, answer|
      (acc[answer.question.id] ||= []).push(answer.id)
      acc
    end

    count = 0
    score = questions_rigth_answers.inject(0) do |acc, question|
      count +=1
      # question is an array with answers id
      if user_right_answers[question[0]]
        if user_right_answers[question[0]].length == question[1].length
          if question[1] & user_right_answers[question[0]] == question[1]
            acc += 1
          end
        end
      end
      acc
    end
    ((score.to_f / count.to_f) * 100).to_i if count!=0
  end
end
