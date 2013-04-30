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

get "/users/:user_url/edit" do
  user = client.accounts.get CGI.unescape(params[:user_url])

  erb :users_edit, :layout => true, :locals => { :user => user }
end

post '/users/:user_url' do
  user = client.accounts.get CGI.unescape(params[:user_url])
  user.given_name = params[:given_name]
  user.surname = params[:surname]
  user.email = params[:email]
  user.save

  redirect '/'
end

delete '/users/:user_url' do
  user = client.accounts.get CGI.unescape(params[:user_url])
  user.delete

  redirect '/'
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
      :flash => { :message => error.message }
    }
  end
end

delete "/session" do
  session.delete(:authenticated)
  redirect "/"
end
