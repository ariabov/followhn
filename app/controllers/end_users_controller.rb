class EndUsersController < AuthenticationController
  def index
    @users = current_end_user.users
    @user  = User.new
    @posts = current_end_user.cached_posts
  end
end
