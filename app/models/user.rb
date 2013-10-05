class User < ActiveRecord::Base
  attr_accessible :username

  validate :validate_user_exists, on: :create

  def validate_user_exists
    invalid = HN::UserSearch.new({username: self.username}).get_users.count == 0
    errors[:base] << "The user with name \"#{username}\" does not exist" if invalid
  end

  def posts
    Post.for_user(self)
  end

  def to_s
    username
  end
end
