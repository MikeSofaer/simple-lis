# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery # :secret => 'bf5c3a08bd102ebcb5614df749715ec4'
end
