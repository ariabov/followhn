class Post
  attr_reader :user, :type, :text, :title, :created_at

  # def self.for_user(user)
  #   HN::Post.for_username(user.username).collect do |p|
  #     Post.new(p, user)
  #   end.sort_by{|p| p.created_at}.reverse
  # end

  def self.for_users
    users = User.scoped
    HN::PostSearch.new({username: users.collect(&:username)}).for_username.collect do |p|
      Post.new(p, users.select{|u| u.username == p[:username]}.first)
    end.sort_by{|p| p.created_at}.reverse
  end

  def initialize(hash, user)
    @type       = hash[:type]
    @text       = hash[:text]
    @title      = hash[:title]
    @created_at = Time.parse(hash[:created_at])
    @user       = user
  end

  def is_comment?
    type == "comment"
  end

  def is_submission?
    type == "submission"
  end

  def created_at_date
    created_at.strftime("%-m/%-d/%Y")
  end
end