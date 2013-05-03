class StormpathSample::App < Sinatra::Base

  get '/account_verifications' do
    settings.client.tenant.verify_account_email params[:sptoken]

    redirect "/session/new"
  end

end
