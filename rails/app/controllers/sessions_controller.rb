class SessionsController < ApplicationController
  before_filter :require_not_logged_in, only: [:new, :create]

  def new
  end

  def create
    begin
      stormpath_account = Stormpath::Rails::Client.authenticate_account params[:username_or_email], params[:password]
      user = User.find_by_stormpath_url stormpath_account.href
      session[:user_id] = user.id
      redirect_to users_path
    rescue Stormpath::Error => error
      flash[:message] = error.message
      render :new
    end
  end

  def destroy
    @current_user = nil
    @is_admin = nil
    session[:user_id] = nil
    redirect_to new_session_path
  end
end
