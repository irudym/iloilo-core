class ApplicationMailer < ActionMailer::Base
  default from: 'password_reset@mg.ilo-ilo.me'
  layout 'mailer'
end
