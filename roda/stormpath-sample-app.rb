# load the ENV['STORMPATH_*] variables
require './env'

if ENV['STORMPATH_API_KEY_FILE_LOCATION'].nil? && ENV['STORMPATH_APPLICATION_URL'].nil?
  raise 'Either STORMPATH_API_KEY_FILE_LOCATION or STORMPATH_APPLICATION_URL must be set'
end

require 'roda'
require 'stormpath-sdk'
require 'cgi'
require 'tilt/erubis'


class SampleApp < Roda
  use Rack::Session::Cookie, secret: 'E0A42D2D-3921-4C61-AD54-792EE8B2C1EF'
  use Rack::MethodOverride
  
  opts[:root] = File.dirname(__FILE__)
  
  opts[:stormpath_client] = Stormpath::Client.new({ :api_key_file_location => ENV['STORMPATH_API_KEY_FILE_LOCATION'] })
  opts[:stormpath_application] = opts[:stormpath_client].applications.get(ENV['STORMPATH_APPLICATION_URL'])
  
  plugin :render #, ext: 'erb', layout: '/layout'
  plugin :static, %w[/images /css]
  plugin :flash
  plugin :multi_route
  Dir['./routes/*.rb'].each{|f| require f}
  plugin :all_verbs
  
  route do |r|
    r.multi_route
    
    # GET /
    r.root do
      r.redirect '/accounts'
    end
    
  end
  
  ## HELPERS
  require_relative 'helpers'
  
end
