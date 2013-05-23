require 'sinatra'
require 'rack-flash'
require 'stormpath-sdk'
require 'stormpath-omniauth'
require 'pry'
require 'pry-debugger'

require_relative 'routes'

class SampleApp < Sinatra::Base

  set :root, File.dirname(__FILE__)

  set :client, Stormpath::Client.new({ :api_key_file_location => ENV['STORMPATH_RUBY_SAMPLE_API_KEY_FILE_LOCATION'] })
  set :application, settings.client.applications.get(ENV['STORMPATH_RUBY_SAMPLE_APPLICATION_URL'])

  enable :sessions

  register Sinatra::SampleApp::Routing

  def self.get_application
    settings.application
  end

  def self.obtain_stormpath_account(email_or_username, password)
    login_request = Stormpath::Authentication::UsernamePasswordRequest.new(email_or_username, password)
    authentication_result = settings.application.authenticate_account login_request
    authentication_result.account
  end

  use OmniAuth::Builder do
    provider :stormpath, setup: -> env {
      env['omniauth.strategy'].options[:stormpath_application] =
        ::SampleApp.get_application
    }
  end
end
