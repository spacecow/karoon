class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(params[:email],params[:password])
    if user
      session_userid(user.id)
      redirect_to root_url, :notice => notify(:logged_in)
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
