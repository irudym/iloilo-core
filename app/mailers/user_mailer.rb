class UserMailer < ApplicationMailer
  def reset_password(user)
    puts "LOG[UserMailer]: key=#{ENV["MAILGUN-API-KEY"]}"
    @user = user
    mail(to: @user.email, subject: 'Reset your password at IloIlo')
  end
end
