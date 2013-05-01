class PasswordResetTokensController < ApplicationController
  def index
    if params[:sptoken]
      redirect_to edit_password_reset_token_path params[:sptoken]
    else
      redirect_to new_password_reset_token_path
    end
  end

  def new
  end

  def create
    begin
      Stormpath::Rails::Client.send_password_reset_email params[:email]
      flash[:message] = 'Password reset email sent.'
      redirect_to new_session_path
    rescue Stormpath::Error => error
      flash[:message] = error.message
      render :new
    end
  end

  def edit
    begin
      @token = params[:id]
      stormpath_account = Stormpath::Rails::Client.verify_password_reset_token @token
      @user = User.find_by_stormpath_url stormpath_account.href
    rescue Stormpath::Error => error
      flash[:message] = error.message
      redirect_to new_password_reset_token_path
    end
  end

  def update
    begin
      @token = params[:id]
      stormpath_account = Stormpath::Rails::Client.verify_password_reset_token @token
      @user = User.find_by_stormpath_url stormpath_account.href
      @user.update_attributes params[:user]
      flash[:message] = 'Password changed. Please log in.'
      redirect_to new_session_path
    rescue Stormpath::Error => error
      flash[:message] = error.message
      redirect_to new_password_reset_token_path
    end
  end
end
