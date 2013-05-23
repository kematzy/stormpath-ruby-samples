module Sinatra
  module SampleApp
    module Routing
      def self.registered(app)
        app.get '/' do
          <<-HTML
          <form action='/auth/stormpath/callback' method='post'>
            <input type='text' name='email_or_username'>
            <input type='password' name='password'>
            <input type='submit' value='Sign in with Stormpath'>
          </form>
          HTML
        end

        app.get '/auth/failure' do
          <<-HTML
          <div>Authentication failed!</div>
          HTML
        end

        app.post '/auth/stormpath/callback' do
          auth = request.env['omniauth.auth']
          "<div>You have successfully authenticated using account with href \"#{auth.uid}\"</div>"
        end
      end
    end
  end
end
