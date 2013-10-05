class EndUsersController < ApplicationController
  def index
    @users = User.all
    @user  = User.new
    @posts = Post.for_users
  end
end
