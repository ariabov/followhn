class User < ActiveRecord::Base
  attr_accessible :username

  before_save :validate_username
  validate :validate_username, on: :create

  def validate_username
    # HN::UserSearch.new({username: self.username}).get_users.count == 0

    errors[:base] << "The user with name \"#{username}\" does not exist"
  end

  def posts
    Post.for_user(self)
  end

  def to_s
    username
  end
end
