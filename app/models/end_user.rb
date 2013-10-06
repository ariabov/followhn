class EndUser < ActiveRecord::Base
  has_and_belongs_to_many :users, 
                          uniq: true,
                          after_add: :update_caches_for

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable #, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :remember_me

  def cached_posts
    post = Post
    Rails.cache.fetch([self.id, self.class.to_s], expires_in: 2.minutes) do
      post.for_users(users.collect(&:id))
    end
  end

  def clear_cache
    Rails.cache.delete([self.id, self.class.to_s])
  end

  def update_caches_for(user)
    user.update_cache
  end

end
