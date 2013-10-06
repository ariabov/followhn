class User < ActiveRecord::Base
  attr_accessible :username

  validate :validate_user_exists, on: :create

  def validate_user_exists
    invalid = HN::UserSearch.new({username: self.username}).get_users.count == 0
    errors[:base] << "The user with name \"#{username}\" does not exist" if invalid
  end

  after_destroy :update_cache
  after_create  :update_cache

  def update_cache
    Post.clear_cache
  end


  def posts
    Post.for_user(self)
  end

  def to_s
    username
  end
end
