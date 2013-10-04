class EndUsersController < ApplicationController
  def index
    @users = User.scoped
  end
end
