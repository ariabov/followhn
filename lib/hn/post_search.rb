module HN
  class PostSearch < HNSearch
    FROM_DATE = (Time.now - 1.year).utc

    attr_reader :username, :parent_sigid

    def initialize(args)
      @username = prepare_username(args[:username])
      @parent_sigid = args[:parent_sigid]
    end

    def get_posts
      bulk_request
    end

    def get_post
      single_request
    end

    def id
      parent_sigid
    end

    protected

    def collection_name
      'items'
    end

    def prepare_bulk_query
      from_date = FROM_DATE.iso8601(0)
      settings = {
        "filter[fields][username]"   => username,
        "limit"                      => 20,
        "filter[fields][create_ts]"  => "[#{from_date} TO *]",
        "sortby"                     => "create_ts desc"
      }
      super(settings)
    end

    def prepare_single_query
      individual_query 
    end

    def prepare_username(usernames)
      usernames.respond_to?(:each) ? "(#{usernames.join(' ')})" : usernames
    end
  end
end