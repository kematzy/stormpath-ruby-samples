Rails.application.config.middleware.use OmniAuth::Builder do
  provider :stormpath, :setup => lambda { |env|
    env['omniauth.strategy'].options[:auth_redirect] = '/session/new'
    env['omniauth.strategy'].options[:authenticator_class] = ::User
    env['omniauth.strategy'].options[:obtain_uid] = Proc.new { |o| o.stormpath_url }
  }
end
