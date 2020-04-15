class Question < ApplicationRecord
  belongs_to :quiz
  has_many :answers
  # DEPRECATED has_many :correct_answers
  
  validates_presence_of :text

  # A hack to decieve the serializer and get answer ids from correct_answers collection
  def right_answer_ids
    correct_answers.map do |answer|
      answer.answer_id
    end
  end

  def destroy_with_answers
    # destory all answers
    self.answers.each do |answer|
      answer.destroy
    end
    self.destroy
  end

  def evaluate(provided_answers)
    user_right_answers = provided_answers.inject([]) do |acc, answer|
      acc << answer[:id].to_i if answer[:attributes][:correct]
      acc
    end
      
    right_answers = self.answers.where(correct: true).map { |answer| answer.id }

    puts "LOG[QuestionModel]: \n==> user_right_answers=#{user_right_answers}\n==> right_answers=#{right_answers}"

    if user_right_answers.length == right_answers.length
      if right_answers & user_right_answers == right_answers
        return { score: 1, answers: user_right_answers }
      end
    end
    { score: 0, answers: user_right_answers }
  end

  def create_answers(object)
    # check if answers provided
    if object[:answers]
      answers = object[:answers][:data].inject([]) do |acc,answer|
        if answer[:type].eql?("answer")
          an = Answer.create!(text: answer[:attributes][:text], correct: answer[:attributes][:correct], question: self) if answer[:type].eql?("answer")
          # check if the answer is correct
          # CorrectAnswer.create!(question: self, answer: an) if answer[:attributes][:correct]
          acc << an
        end
      end

      # DEPRECATED check if correct answers provided
      # if object[:right_answers]
      #  object[:right_answers][:data].map do |correct|
      #    CorrectAnswer.create!(question: self, answer: answers[correct[:attributes][:index].to_i])
      #  end
      # end
    end
  end

  def update_answers(object)
    answerids = self.answer_ids
    if object[:answers]
      provided_ids = object[:answers][:data].inject([]) do |acc, answer|
        if answer[:type].eql?("answer")
          ans = nil
          if answer[:id]
            ans = Answer.find(answer[:id])
            ans.update!(text: answer[:attributes][:text], correct: answer[:attributes][:correct]) if ans
            acc << answer[:id].to_i
          end
          if !ans 
            Answer.create!(question: self, text: answer[:attributes][:text], correct: answer[:attributes][:correct])
          end
        end
        acc
      end
      
      # delete unused answers
      answerids.map do |id|
        unless provided_ids.include?(id) 
          self.answers.find(id).destroy
        end 
      end
    end
  end

end
