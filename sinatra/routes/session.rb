class StormpathSample::App < Sinatra::Base

  get "/session/new" do
    require_logged_out

    erb :login, :layout => true
  end

  post "/session" do
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
      render_view :login, {
        :flash => {
          :message => error.message
        }
      }
    end
  end

  delete "/session" do
    require_logged_in

    session.delete(:authenticated)
    session.delete(:email_or_username)

    redirect "/session/new"
  end

end
