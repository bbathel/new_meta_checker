class AuthController < ApplicationController
   skip_before_filter :load_session

 def access_denied
 end

 def logout
   session.delete('cas')
   redirect_to  ENV['CAS_BASE_URL'] + "/logout?service=#{request.protocol + request.host_with_port}"
 end
end
