#!/usr/bin/env ruby

require "sinatra"
require "stormpath-sdk"

client = Stormpath::Client.new({
  api_key_file_location: ENV["STORMPATH_RUBY_SAMPLE_API_KEY_FILE_LOCATION"]
})

application = client.applications.get(ENV["STORMPATH_RUBY_SAMPLE_APPLICATION_URL"])
directory = client.directories.get(ENV["STORMPATH_RUBY_SAMPLE_DIRECTORY_URL"])

get "/" do
  # check to see if user is logged in
  # if not, go to /session/new
  # otherwise, go to /users
  erb :users, { locals: { users: application.accounts, layout: true } }
end
