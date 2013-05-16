class SessionsController < ApplicationController
  def new
  end

  def create
    if user = User.from_omniauth(env['omniauth.auth'])
      user = User.from_omniauth(request.env["omniauth.auth"])
      session[:user_id] = user.id
      redirect_to root_url, notice: "Signed in"
    end
  end
end