class StormpathSample::App < Sinatra::Base

  get "/accounts" do
    require_logged_in

    render_view :accounts, { :accounts => settings.application.accounts }
  end

  get "/accounts/:account_url/edit" do
    require_logged_in

    account = settings.client.accounts.get CGI.unescape(params[:account_url])

    render_view :accounts_edit, { :account => account }
  end

  patch '/accounts/:account_url' do
    require_logged_in

    account = settings.client.accounts.get CGI.unescape(params[:account_url])
    account.given_name = params[:given_name]
    account.surname = params[:surname]
    account.email = params[:email]
    account.save

    redirect '/accounts'
  end

  delete '/accounts/:account_url' do
    require_logged_in

    account = settings.client.accounts.get CGI.unescape(params[:account_url])
    account.delete

    redirect '/accounts'
  end

  get '/accounts/new' do
    account = Stormpath::Resource::Account.new({})

    render_view :accounts_new, { :account => account }
  end

  post '/accounts' do
    account_params  = params.select do |k, v|
      %W[given_name surname email username password].include?(k)
    end

    account = Stormpath::Resource::Account.new account_params

    begin
      settings.directory.accounts.create account
      redirect "/session/new"
    rescue Stormpath::Error => error
      render_view :accounts_new, {
        :account => account,
        :flash => { :message => error.message }
      }
    end
  end
end
