# load the ENV['STORMPATH_*] variables
require './env'

if ENV['STORMPATH_API_KEY_FILE_LOCATION'].nil? &&  ENV['STORMPATH_APPLICATION_URL'].nil?
  raise 'Either STORMPATH_API_KEY_FILE_LOCATION or STORMPATH_APPLICATION_URL must be set'
end

require 'roda'
require 'stormpath-sdk'
require 'stormpath-omniauth'
require 'cgi'
require 'tilt/erubis'
require 'pry'
require 'pry-byebug'


class SampleApp < Roda
  use Rack::Session::Cookie, secret: 'E0A42D2D-3921-4C61-AD54-792EE8B2C1EF'
  use Rack::MethodOverride
  
  opts[:root] = File.dirname(__FILE__)
  
  opts[:stormpath_client] = Stormpath::Client.new({ :api_key_file_location => ENV['STORMPATH_API_KEY_FILE_LOCATION'] })
  opts[:stormpath_app] = opts[:stormpath_client].applications.get(ENV['STORMPATH_APPLICATION_URL'])
  
  plugin :h
  plugin :render #, ext: 'erb', layout: '/layout'
  plugin :static, %w[/images /css]
  plugin :flash
  plugin :multi_route
  Dir['./routes/*.rb'].each{|f| require f}
  plugin :all_verbs
  
  
  
  use OmniAuth::Builder do
    provider :stormpath, setup: -> env {
      env['omniauth.strategy'].options[:stormpath_application] = ::SampleApp.get_application
    }
  end
  
  route do |r|
    
    r.root do
      <<-HTML
      <form action='/auth/stormpath/callback' method='post'>
        <p><label for="email_or_username">Email / Username:</label> &nbsp; <input type='text' name='email_or_username'></p>
        <p><label for="password">Password:</label> &nbsp; <input type='password' name='password'></p>
        <p><input type='submit' value='Sign in with Stormpath'></p>
      </form>
      HTML
    end
    
    r.on 'auth' do
      
      r.get 'failure' do
        <<-HTML
        <div>Authentication failed!</div>
        HTML
      end
      
      r.post 'stormpath/callback' do
        auth = request.env['omniauth.auth']
        "<div>You have successfully authenticated using account with href \"#{h auth.inspect}\"</div>"
      end
      
    end
    
  end
  
  
  def self.get_application
    opts[:stormpath_app]
  end
  
  def self.obtain_stormpath_account(email_or_username, password)
    login_request = Stormpath::Authentication::UsernamePasswordRequest.new(email_or_username, password)
    authentication_result = opts[:stormpath_app].authenticate_account( login_request )
    authentication_result.account
  end
  
end
