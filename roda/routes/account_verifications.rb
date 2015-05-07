SampleApp.route("account_verifications") do |r|
  
  
  # GET /account_verifications
  r.get do
    opts[:stormpath_client].accounts.verify_email_token r[:sptoken]
    flash[:notice] = 'Your account has been verified and you are now able to log in.'
    r.redirect '/session/new'
  end
  
end
