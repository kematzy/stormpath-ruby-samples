#!/usr/bin/env ruby

require "sinatra"
require "stormpath-sdk"

client = Stormpath::Client.new({
  api_key_file_location: ENV["STORMPATH_RUBY_SAMPLE_API_KEY_FILE_LOCATION"]
})

application = client.applications.get(ENV["STORMPATH_RUBY_SAMPLE_APPLICATION_URL"])
directory = client.directories.get(ENV["STORMPATH_RUBY_SAMPLE_DIRECTORY_URL"])

enable :sessions
enable :method_override

get "/" do
  # check to see if user is logged in
  # if not, go to /session/new
  # otherwise, go to /users
  if session[:authenticated]
    redirect "/users"
  else
    redirect "/session/new"
  end
end

get "/users" do
  erb :users, :layout => true, :locals => {
    :session => session, :users => application.accounts
  }
end

get "/session/new" do
  erb :login, :layout => true
end

post "/session" do
  email = params[:email]
  password = params[:password]

  login_request = Stormpath::Authentication::UsernamePasswordRequest.new(
    email,
    password
  )

  begin
    authentication_result = application.authenticate_account login_request
    session[:authenticated] = true
    redirect "/"
  rescue Stormpath::Error => error
    erb :login, :layout => true, :locals => {
      :flash => {
        :message => "We were unable to log you in"
      }
    }
  end
end

delete "/session" do
  session.delete(:authenticated)
  redirect "/"
end
