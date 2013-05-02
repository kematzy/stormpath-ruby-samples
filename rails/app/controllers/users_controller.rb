require 'pry-debugger'

class UsersController < ApplicationController
  before_filter :require_login
  skip_before_filter :require_login, only: [:new, :create, :verify]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    User.create params[:user]

    redirect_to users_path
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes params[:user]
      redirect_to users_path
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])

    unless @user == current_user
      @user.destroy
    else
      flash[:message] = "You can not delete your own account!"
    end

    redirect_to users_path
  end

  def verify
    begin
      Stormpath::Rails::Client.verify_account_email params[:sptoken]
      flash[:message] = 'Your account has been verified. Please log in using your username and password'
    rescue Stormpath::Error => error
      flash[:message] = error.message
    end

    redirect_to new_session_path
  end
end
