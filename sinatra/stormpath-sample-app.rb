#!/usr/bin/env ruby

require 'sinatra'
require 'stormpath-sdk'

require_relative 'helpers'
require_relative 'routes/init'

class SampleApp < Sinatra::Base

  set :root, File.dirname(__FILE__)

  set :client, Stormpath::Client.new({ :api_key_file_location => ENV['STORMPATH_RUBY_SAMPLE_API_KEY_FILE_LOCATION'] })
  set :application, settings.client.applications.get(ENV['STORMPATH_RUBY_SAMPLE_APPLICATION_URL'])
  set :directory, settings.client.directories.get(ENV['STORMPATH_RUBY_SAMPLE_DIRECTORY_URL'])

  enable :sessions
  enable :method_override

  helpers Sinatra::SampleApp::Helpers

  register Sinatra::SampleApp::Routing::Accounts
  register Sinatra::SampleApp::Routing::AccountVerifications
  register Sinatra::SampleApp::Routing::Main
  register Sinatra::SampleApp::Routing::PasswordResetTokens
  register Sinatra::SampleApp::Routing::Session

end
