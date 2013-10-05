module HN
  class PostSearch < HNSearch
    attr_reader :username

    def initialize(args)
      @username = prepare_username(args[:username])
    end

    def get_posts
      request_data
    end

    protected

    def collection_name
      'items'
    end

    def prepare_query
      settings = {
        "filter[fields][username]" => username,
        "limit"                    => 20
      }
      super(settings)
    end

    def prepare_username(usernames)
      usernames.respond_to?(:each) ? "(#{usernames.join(' ')})" : usernames
    end
  end
end