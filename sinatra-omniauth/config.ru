require File.dirname(__FILE__) + '/stormpath-sample-app'

OmniAuth.config.on_failure = Proc.new { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}

run SampleApp
