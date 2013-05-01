require 'stormpath-rails'

class User < ActiveRecord::Base
  include Stormpath::Rails::Account

  attr_accessible :css_background
end
