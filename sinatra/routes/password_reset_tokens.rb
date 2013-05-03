require 'sinatra/base'

module Sinatra
  module SampleApp
    module Routing
      module PasswordResetTokens

        def self.registered(app)

          app.get '/password_reset_tokens/new' do
            render_view :password_reset_new
          end

          app.get '/password_reset_tokens' do
            account = settings.application.verify_password_reset_token params[:sptoken]

            redirect "/password_reset_tokens/#{CGI.escape(account.href)}"
          end

          app.post '/password_reset_tokens' do
            begin
              settings.application.send_password_reset_email params[:email]
              redirect '/session/new'
            rescue Stormpath::Error => error
              render_view :password_reset_new, {
                :flash => { :message => error.message }
              }
            end
          end

          app.get '/password_reset_tokens/:account_url' do
            account = settings.client.accounts.get CGI.unescape(params[:account_url])

            render_view :password_reset_tokens_edit, { :account => account }
          end

          app.patch '/password_reset_tokens/:account_url' do
            account = settings.client.accounts.get CGI.unescape(params[:account_url])
            account.password = params[:password]
            account.save

            redirect '/session/new'
          end
        end

      end
    end
  end
end
