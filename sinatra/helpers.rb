StormpathSample::App.helpers do

  def render_view(view, locals={})
    locals = { :session => session }.merge locals
    erb view, :layout => true, :locals => locals
  end

  def require_logged_in()
    redirect('/session/new') unless session[:authenticated]
  end

  def require_logged_out()
    redirect('/accounts') if session[:authenticated]
  end

end
