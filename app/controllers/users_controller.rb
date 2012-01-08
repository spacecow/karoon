class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      session_userid(@user.id)
      redirect_to books_path, :notice => notify(:signed_up_and_logged_in)
    else
      render :new
    end
  end
end
