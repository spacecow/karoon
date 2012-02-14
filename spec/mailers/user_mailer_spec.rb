require "spec_helper"

describe UserMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  it "sends a signup mail" do
    user = Factory(:user,:email => 'jsveholm@gmail.com')
    token = user.signup_tokens.first.token
    @email = UserMailer.signup(user,signup_confirmation_url(token))
    @email.should deliver_to('jsveholm@gmail.com')
    @email.should have_body_text(/Activation link:.*#{token}/)
  end
end
