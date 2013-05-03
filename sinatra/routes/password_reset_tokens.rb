class StormpathSample::App < Sinatra::Base

  get '/password_reset_tokens/new' do
    render_view :password_reset_new
  end

  get '/password_reset_tokens' do
    account = settings.application.verify_password_reset_token params[:sptoken]

    redirect "/password_reset_tokens/#{CGI.escape(account.href)}"
  end

  post '/password_reset_tokens' do
    begin
      settings.application.send_password_reset_email params[:email]
      redirect '/session/new'
    rescue Stormpath::Error => error
      render_view :password_reset_new, {
        :flash => { :message => error.message }
      }
    end
  end

  get "/password_reset_tokens/:account_url" do
    account = settings.client.accounts.get CGI.unescape(params[:account_url])

    render_view :password_reset_tokens_edit, { :account => account }
  end

  patch '/password_reset_tokens/:account_url' do
    account = settings.client.accounts.get CGI.unescape(params[:account_url])
    account.password = params[:password]
    account.save

    redirect '/session/new'
  end

end
