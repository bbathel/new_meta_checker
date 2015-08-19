class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  prepend_before_filter :load_session
  #before_filter :require_login

  def load_session
   if session['cas'].try(:[], 'user')
     @current_user = User.find_by_email(session['cas']['user'])

     if @current_user
       unless session['cas']['extra_attributes']['authorizations'].include? 'meta-checker'
         redirect_to '/auth/access_denied'
       end
        @current_user['google_refresh_token']
        session[:expires_at] = Time.zone.now + 8.hours
        client = Google::APIClient.new
        auth = client.authorization
        auth.client_id = ENV['GID']
        auth.client_secret = ENV['GSECRET']
        auth.scope =
            "https://www.googleapis.com/auth/drive " +
            "https://spreadsheets.google.com/feeds/"
        auth.redirect_uri = "#{ENV['CAS_BASE_URL']}#{ENV['OAUTH_PATH']}"
        auth.refresh_token = @current_user['google_refresh_token']
        auth.fetch_access_token!
        @session = GoogleDrive.login_with_oauth(auth.access_token)
        #@files = @session.spreadsheet_by_key("1WhAbfRwvfMZO_ON38iWKQZup4a-s48IyorPnhDL_O-s").worksheets[1]
        
     end
   else
     @current_user = nil
   end
  end

 def current_user
   @current_user
 end

 def require_login
   if !@current_user || session[:expires_at] < Time.zone.now
     render :text => '401 unauthorized', :status => :unauthorized
   end
 end
  def current_user_id
    @current_user = session['cas']

  end
end
