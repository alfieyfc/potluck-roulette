class ApplicationMailer < ActionMailer::Base
  default from: ENV["GMAIL_SMTP_ACCOUNT"]
  layout "mailer"
end
