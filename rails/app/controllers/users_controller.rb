require 'pry-debugger'

class UsersController < ApplicationController
  before_filter :require_login
  skip_before_filter :require_login, only: [:new, :create]

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

  def delete
    @user = User.find(params[:id])
    @user.delete

    redirect_to users_path
  end
end
