class AuthenticationController < ApplicationController
  before_filter :redirect_if_not_logged_in

  def redirect_if_not_logged_in
    redirect_to new_end_user_session_path unless current_end_user
  end
end