class Message
  def self.quiz_started
    'The quiz already started, stop it before start again'
  end 

  def self.invalid_credentials
    'Invalid credentials'
  end

  def self.invalid_token
    'Invalid token'
  end

  def self.missing_token
    'Missing token'
  end

  def self.unathorized
    'Unauthorized request'
  end

  def self.account_created
    'Account created successfully'
  end

  def self.account_not_created
    'Account not be created'
  end

  def self.expired_token
    'Sorry, your token has expired, Please login to continue'
  end

  def self.need_to_login
    'You need to loging before posting any question'
  end

  def self.wrong_quiz_id
    'You are trying to change a question for unexisting qiuz'
  end
end