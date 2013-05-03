module Sinatra
  module SampleApp
    module Routing
      module Session

        def self.registered(app)

          app.get "/session/new" do
            require_logged_out

            erb :login, :layout => true
          end

          app.post "/session" do
            require_logged_out

            email_or_username = params[:email_or_username]
            password = params[:password]

            login_request = Stormpath::Authentication::UsernamePasswordRequest.new(
              email_or_username,
              password
            )

            begin
              authentication_result = settings.application.authenticate_account login_request
              session[:authenticated] = true
              session[:email_or_username] = email_or_username
              redirect "/accounts"
            rescue Stormpath::Error => error
              flash[:notice] = error.message
              render_view :login
            end
          end

          app.delete "/session" do
            require_logged_in

            session.delete(:authenticated)
            session.delete(:email_or_username)
            flash[:notice] = "You have been logged out successfully."

            redirect "/session/new"
          end

        end

      end
    end
  end
end
