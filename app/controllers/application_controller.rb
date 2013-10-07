class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from HNSearchServiceUnavailable do |exception|
    redirect_to root_path, alert:  "The service is temporary unavailable. Please try again shortly."
  end
end
