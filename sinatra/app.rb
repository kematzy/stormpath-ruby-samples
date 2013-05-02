#!/usr/bin/env ruby

require "sinatra"
require "stormpath-sdk"

client = Stormpath::Client.new({
  api_key_file_location: ENV["STORMPATH_RUBY_SAMPLE_API_KEY_FILE_LOCATION"]
})

application = client.applications.get(ENV["STORMPATH_RUBY_SAMPLE_APPLICATION_URL"])
directory = client.directories.get(ENV["STORMPATH_RUBY_SAMPLE_DIRECTORY_URL"])

set :root, File.dirname(__FILE__)
enable :sessions
enable :method_override

def render_view(view, locals={})
  locals = { :session => session }.merge locals
  erb view, :layout => true, :locals => locals
end

def require_logged_in()
  redirect('/sessions/new') unless session[:authenticated]
end

def require_logged_out()
  redirect('/accounts') if session[:authenticated]
end

get "/" do
  redirect "/accounts"
end

before "/sessions/new" do
  require_logged_out
end

before '/accounts*' do
  require_logged_in
end

get "/accounts" do
  render_view :accounts, { :accounts => application.accounts }
end

get "/accounts/:account_url" do
  account = client.accounts.get CGI.unescape(params[:account_url])

  render_view :accounts_edit, { :account => account }
end

patch '/accounts/:account_url' do
  account = client.accounts.get CGI.unescape(params[:account_url])
  account.given_name = params[:given_name]
  account.surname = params[:surname]
  account.email = params[:email]
  account.save

  redirect '/accounts'
end

delete '/accounts/:account_url' do
  account = client.accounts.get CGI.unescape(params[:account_url])
  account.delete

  redirect '/accounts'
end

get '/accounts/new' do
  account = Stormpath::Resource::Account.new({})

  render_view :accounts_new, { :account => account }
end

post '/accounts' do
  account_params  = params.select do |k, v|
    %W[given_name surname email username password].include?(k)
  end

  account = Stormpath::Resource::Account.new account_params

  begin
    directory.accounts.create account
    redirect "/session/new"
  rescue Stormpath::Error => error
    render_view :accounts_new, {
      :account => account,
      :flash => { :message => error.message }
    }
  end
end

get '/account_verifications' do
  client.tenant.verify_account_email params[:sptoken]

  redirect "/session/new"
end

get "/session/new" do
  erb :login, :layout => true
end

post "/session" do
  email_or_username = params[:email_or_username]
  password = params[:password]

  login_request = Stormpath::Authentication::UsernamePasswordRequest.new(
    email_or_username,
    password
  )

  begin
    authentication_result = application.authenticate_account login_request
    session[:authenticated] = true
    session[:email_or_username] = email_or_username
    redirect "/accounts"
  rescue Stormpath::Error => error
    render_view :login, {
      :flash => {
        :message => error.message
      }
    }
  end
end

delete "/session" do
  session.delete(:authenticated)
  session.delete(:email_or_username)
  redirect "/"
end

get '/password_reset_tokens/new' do
  render_view :password_reset_new
end

get '/password_reset_tokens' do
  account = application.verify_password_reset_token params[:sptoken]

  redirect "/password_reset_tokens/#{CGI.escape(account.href)}"
end

post '/password_reset_tokens' do
  begin
    application.send_password_reset_email params[:email]
    redirect '/session/new'
  rescue Stormpath::Error => error
    render_view :password_reset_new, {
      :flash => { :message => error.message }
    }
  end
end

get "/password_reset_tokens/:account_url" do
  account = client.accounts.get CGI.unescape(params[:account_url])

  render_view :password_reset_tokens_edit, { :account => account }
end

patch '/password_reset_tokens/:account_url' do
  account = client.accounts.get CGI.unescape(params[:account_url])
  account.password = params[:password]
  account.save

  redirect '/session/new'
end
