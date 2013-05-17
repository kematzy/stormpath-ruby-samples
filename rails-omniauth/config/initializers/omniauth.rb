Rails.application.config.middleware.use OmniAuth::Builder do
  provider :stormpath, '/session/new'
end
