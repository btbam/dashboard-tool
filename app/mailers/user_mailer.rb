class UserMailer < ActionMailer::Base
  default from: 'dashboard@dashboard.com'

  def invitation_email(user, invited_by)
    @user = user
    @invited_by = invited_by
    @url = 'http://dashboard-claim.dashboard.net'

    mail(to: @user.email, subject: "You've been invited to use Dashboard 2.0!")
  end
end
