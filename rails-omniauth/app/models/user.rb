require 'stormpath-rails'

puts "\n==============================="
puts Stormpath
puts Stormpath::Rails

class User < ActiveRecord::Base
  include Stormpath::Rails::Account

  def self.from_omniauth(auth)
    find_by_stormpath_url(auth["uid"])
  end
end