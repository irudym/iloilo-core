class ApplicationMailer < ActionMailer::Base
  default from: 'password_reset@ilo-ilo.me'
  layout 'mailer'
end
