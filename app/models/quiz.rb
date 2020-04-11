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
              qst.update!(text: question[:attributes][:text]) if qst
              qst.update_answers(question[:relationships])
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
end
