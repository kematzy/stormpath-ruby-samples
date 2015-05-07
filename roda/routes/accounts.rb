SampleApp.route("accounts") do |r|
  
  r.is do
    
    # GET /accounts
    r.get do
      require_logged_in
      
      accounts = opts[:stormpath_application].accounts.map do |account|
        {
          :username     => account.username,
          :email        => account.email,
          :edit_route   => "/accounts/#{CGI.escape(account.href)}/edit",
          :delete_route => "/accounts/#{CGI.escape(account.href)}",
          :deletable    => is_admin?
        }
      end
      
      render_view(:accounts, { :accounts => accounts })
    end
    
    
    # POST /accounts
    r.post do
      # h r.params.inspect
      account_params  = r.params.select do |k, v|
        %W[given_name surname email username password].include?(k)
      end
      
      account = Stormpath::Resource::Account.new account_params
      
      begin
        opts[:stormpath_application].accounts.create( account )
        flash[:notice] = 'Your account was created successfully. Depending on directory configuration, you may need to validate account-creation through email.'
        r.redirect '/session/new'
      rescue Stormpath::Error => error
        flash.now[:notice] = error.message
        render_view(:accounts_new, { :account => account })
      end
    end
    
  end
  
  
  # GET /accounts/new
  r.get 'new' do
    account = Stormpath::Resource::Account.new({})
    render_view(:accounts_new, { :account => account })
  end
  
  r.on ':account_url' do |account_url|
    
    # PATCH /accounts/:account_url
    r.patch do
      require_logged_in
      
      account             = opts[:stormpath_client].accounts.get CGI.unescape( account_url )
      account.given_name  = r[:given_name]
      account.surname     = r[:surname]
      account.email       = r[:email]
      account.save
      
      flash[:notice] = 'Account edited successfully.'
      
      r.redirect '/accounts'
    end
    
    
    # DELETE /accounts/:account_url 
    r.delete do
      require_logged_in
      
      account = opts[:stormpath_client].accounts.get CGI.unescape( account_url )
      account.delete
      
      flash[:notice] = 'Account deleted successfully'
      
      r.redirect '/accounts'
    end
    
    
    # GET /accounts/:account_url/edit
    r.get 'edit' do
      require_logged_in
      
      account = opts[:stormpath_client].accounts.get CGI.unescape( account_url )
      
      render_view(:accounts_edit, { :account => account })
    end
    
    
  end
  
  
end
