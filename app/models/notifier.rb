class Notifier < ActionMailer::Base
  default :from => "no-reply@fudys.com",
          :url => "#{APP_CONFIG['domain']}"

  def password_reset_instructions(user)
    @user = user
    mail(:to => @user.email,
          :subject => "[#{APP_CONFIG['domain']}] password reset instructions"
          )
  end

  def verification_instructions(user)
    @user = user
    mail(:to => @user.email,
         :subject => "[#{APP_CONFIG['domain']}] email verification"
         )
  end

end