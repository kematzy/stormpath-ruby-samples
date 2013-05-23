OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :stormpath, :setup => lambda { |env|
    env['omniauth.strategy'].options[:auth_redirect] = '/session/new'
    env['omniauth.strategy'].options[:authenticator_method] = ::User.method(:authenticate)
    env['omniauth.strategy'].options[:obtain_uid_method] = Proc.new { |o| o.stormpath_url }
  }
end
