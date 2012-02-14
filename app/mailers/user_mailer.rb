class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  def signup(user,signup_confirmation_url)
    @user = user
    @signup_confirmation_url = signup_confirmation_url
    mail(:to => user.email)
  end
end
