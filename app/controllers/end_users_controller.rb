class EndUsersController < AuthenticationController
  def index
    @users = current_end_user.users
    @user  = User.new
    @posts = current_end_user.cached_posts
    @timeline_start = HN::PostSearch::FROM_DATE.strftime("%-m/%-d/%Y")
  end
end
