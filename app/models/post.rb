class Post
  attr_reader :user, :type, :text, :title, :created_at,
              :parent_id, :parent_title, :parent_object

  def self.for_users(ids=[])
    users = User.where(id: ids)
    HN::PostSearch.new({username: users.collect(&:username)}).get_posts.collect do |p|
      Post.new(p, users.select{|u| u.username == p[:username]}.first)
    end.sort_by{|p| p.created_at}.reverse
  end

  def initialize(hash, user, lookup_parent=true)
    return if hash.blank?
    @type          = hash[:type]
    @text          = hash[:text]
    @title         = hash[:title]
    @parent_id     = hash[:discussion]["id"] if hash[:discussion]
    @parent_title  = hash[:discussion]["title"] if hash[:discussion]
    @parent_object = Post.new(HN::PostSearch.new({parent_sigid: hash[:parent_sigid]}).get_post, nil, false) if hash[:parent_sigid] && lookup_parent
    @created_at    = Time.parse(hash[:created_at])
    @user          = user
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

  def url
    ["https://news.ycombinator.com/item?id=", parent_id].join('')
  end
end