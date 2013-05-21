class PasswordResetTokensController < ApplicationController
  before_filter :set_token

  def new
    redirect_to password_reset_path(@token) if @token
  end

  def create
    begin
      User.send_password_reset_email params[:email]
      flash[:message] = 'Password reset email sent.'
      redirect_to new_session_path
    rescue Stormpath::Error => error
      flash.now[:message] = error.message
      render :new
    end
  end

  def edit
    begin
      @user = User.verify_password_reset_token @token
    rescue Stormpath::Error => error
      flash[:message] = error.message
      redirect_to new_password_reset_token_path
    end
  end

  def update
    begin
      @user = User.verify_password_reset_token @token
      if @user.update_attributes params[:user]
        flash[:message] = 'Password changed. Please log in.'
        redirect_to new_session_path
      else
        flash.now[:message] = error_message_for(@user)
        render :edit
      end
    rescue Stormpath::Error => error
      flash[:message] = error.message
      redirect_to new_password_reset_token_path
    end
  end

  private

  def set_token
    @token = params[:sptoken]
  end
end
