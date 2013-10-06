module HN
  class PostSearch < HNSearch
    FROM_DATE = (Time.now - 1.year).utc

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
      from_date = FROM_DATE.iso8601(0)
      settings = {
        "filter[fields][username]"   => username,
        "limit"                      => 100,
        "filter[fields][create_ts]"  => "[#{from_date} TO *]",
        "sortby"                     => "create_ts desc"
      }
      super(settings)
    end

    def prepare_username(usernames)
      usernames.respond_to?(:each) ? "(#{usernames.join(' ')})" : usernames
    end
  end
end