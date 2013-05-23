require 'stormpath-rails'

class User < ActiveRecord::Base
  include Stormpath::Rails::Account

  attr_accessible :email, :password, :given_name, :surname, :username

  def self.from_omniauth(auth)
    find_by_stormpath_url(auth["uid"])
  end
end
