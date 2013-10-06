class EndUsersController < AuthenticationController#ApplicationController
  def index
    @users = User.all
    @user  = User.new
    @posts = Post.cached_posts
  end
end
