class User < ActiveRecord::Base
  has_and_belongs_to_many :end_users,
                          uniq: true

  attr_accessible :username

  validate :validate_user_exists, on: :create

  def validate_user_exists
    invalid = HN::UserSearch.new({username: self.username}).get_users.count == 0
    errors[:base] << "The user with name \"#{username}\" does not exist" if invalid
  end

  def update_cache
    end_users.each{|eu| eu.clear_cache }
  end

  def posts
    Post.for_user(self)
  end

  def to_s
    username
  end
end