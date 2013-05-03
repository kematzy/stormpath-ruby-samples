class StormpathSample::App < Sinatra::Base

  get "/" do
    redirect "/accounts"
  end

end
