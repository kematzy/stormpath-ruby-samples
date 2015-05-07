SampleApp.route("session") do |r|
  
  
  r.is do
    
    
    # POST /session
    r.post do
      require_logged_out
      
      email_or_username = r[:email_or_username]
      password          = r[:password]
      
      login_request = Stormpath::Authentication::UsernamePasswordRequest.new(
        email_or_username,
        password
      )
      
      begin
        authentication_result = opts[:stormpath_application].authenticate_account login_request
        
        initialize_session email_or_username, authentication_result.account.href
        
        r.redirect '/accounts'
      rescue Stormpath::Error => error
        flash.now[:notice] = error.message
        view(:login)
      end
      
    end
    
    
    # DELETE /session
    r.delete do
      require_logged_in
      
      destroy_session
      
      flash[:notice] = 'You have been logged out successfully.'
      r.redirect '/session/new'
    end
    
    
  end
  
  
  # GET /session/new
  r.get 'new' do
    require_logged_out
    view(:login)
  end
  
  
end
