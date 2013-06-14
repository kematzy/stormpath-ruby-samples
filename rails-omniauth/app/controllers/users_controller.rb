class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.create params[:user]
    if @user.errors[:base].empty?
      flash[:message] = "Your account has been created. Depending on how you've configured your directory, you may need to check your email and verify the account before logging in."
      redirect_to new_session_path
    else
      render :new
    end
  end
end
