class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      session_userid(@user.id)
      flash[:notice] = notify(:signed_up_and_logged_in)
      if session[:original_url]
        url = session[:original_url]
        session[:original_url] = nil
        redirect_to url and return
      end
      redirect_to root_url
    else
      render :new
    end
  end
end
