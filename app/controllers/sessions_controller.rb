class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(params[:email],params[:password])
    if user
      if user.signup_token.nil?
        redirect_to login_url, :alert => alertify(:account_not_activated)
      else
        session_userid(user.id)
        flash[:notice] = notify(:logged_in)
        if session_original_url
          url = session_original_url
          session_original_url(nil)
          redirect_to url and return
        end
        redirect_to root_url
      end
    else
      flash.now.alert = alertify(:invalid_login_or_password)
      render :new
    end
  end

  def destroy
    session_userid(nil)
    redirect_to root_url, :notice => notify(:logged_out)
  end
end
