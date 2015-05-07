class SampleApp
  
  def render_view(tmpl, locals={})
    locals = { :session => session }.merge locals
    view(tmpl, :layout => true, :locals => locals)
  end
  
  def require_logged_in()
    request.redirect('/session/new') unless is_authenticated?
  end
  
  def require_logged_out()
    request.redirect('/accounts') if is_authenticated?
  end
  
  def is_authenticated?()
    return !!session[:stormpath_account_url]
  end
  
  def initialize_session(display_name, stormpath_account_url)
    session[:display_name]          = display_name
    session[:stormpath_account_url] = stormpath_account_url
  end
  
  def destroy_session()
    session.delete(:display_name)
    session.delete(:stormpath_account_url)
    @is_admin = false
  end
  
  def is_admin?()
    if not @is_admin
      account = opts[:stormpath_client].accounts.get(session[:stormpath_account_url])
      @is_admin = account.groups.any? do |group|
        group.name == ADMIN_GROUP_NAME
      end
    end
    
    @is_admin
  end
  
end
