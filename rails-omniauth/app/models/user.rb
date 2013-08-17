require 'stormpath-rails'

class User < ActiveRecord::Base
  include Stormpath::Rails::Account

  attr_accessible :email, :password, :given_name, :surname, :username, :stormpath_url

  def self.from_omniauth(auth)
    where(stormpath_url: auth["uid"]).first_or_create
  end
end
