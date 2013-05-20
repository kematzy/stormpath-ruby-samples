require 'pry'
require 'pry-debugger'

class ApplicationController < ActionController::Base

  ADMIN_GROUP_NAME = "admin"

  protect_from_forgery

  helper_method :logged_in?, :current_user, :is_admin?

  def current_user
    @current_user ||= User.where(id: session[:user_id]).first
  end

  def error_message_for resource
    resource.errors[:base].join ' '
  end

  def is_admin?
    if session[:user_id] and not @is_admin
      account = Stormpath::Rails::Client.find_account current_user.stormpath_url
      @is_admin = account.groups.any? do |group|
        group.name == ADMIN_GROUP_NAME
      end
    end
  end

  def logged_in?
    !!current_user
  end

  def require_not_logged_in
    if logged_in?
      redirect_to root_path
    end
  end

  def require_login
    unless logged_in?
      redirect_to new_session_path
    end
  end
end
