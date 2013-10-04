class User < ActiveRecord::Base
  attr_accessible :username

  def posts
    Post.for_user(self)
  end

  def to_s
    username
  end
end
