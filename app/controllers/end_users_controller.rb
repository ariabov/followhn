class EndUsersController < ApplicationController
  def index
    @users = User.all
    @posts = Post.for_users
  end
end
