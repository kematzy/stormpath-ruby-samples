SampleApp.route("password_reset_tokens") do |r|
  
  r.is do
    
    
    # GET /password_reset_tokens
    r.get do
      account = opts[:stormpath_application].verify_password_reset_token(r[:sptoken])
      r.redirect "/password_reset_tokens/#{CGI.escape(account.href)}"
    end
    
    
    # POST /password_reset_tokens
    r.post do
      
      begin
        opts[:stormpath_application].send_password_reset_email(r[:email])
        r.redirect '/session/new'
      rescue Stormpath::Error => error
        flash.now[:error] = error.message
        render_view(:password_reset_new)
      end
      
    end
    
  end
  
  
  # GET /password_reset_tokens/new
  r.get 'new' do
    render_view(:password_reset_new)
  end
  
  
  # ROUTE /password_reset_tokens
  r.on ':account_url' do |account_url|
    
    # GET /password_reset_tokens/:account_url
    r.get do
      account = opts[:stormpath_client].accounts.get CGI.unescape( account_url )
      
      render_view(:password_reset_tokens_edit, { :account => account })
    end
    
    
    # PATCH /password_reset_tokens/:account_url
    r.patch do
      account = opts[:stormpath_client].accounts.get CGI.unescape( account_url )
      account.password = r[:password]
      account.save
      
      r.redirect '/session/new'
    end
    
  end
  
  
end
