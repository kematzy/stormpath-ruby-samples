require 'sinatra/base'

module Sinatra
  module SampleApp
    module Routing
      module AccountVerifications

        def self.registered(app)

          app.get '/account_verifications' do
            settings.client.accounts.verify_email_token params[:sptoken]

            flash[:notice] = 'Your account has been verified and you are now able to log in.'

            redirect '/session/new'
          end

        end

      end
    end
  end
end
