module HN
  class UserSearch < HNSearch
    attr_reader :username

    def initialize(args)
      @username = args[:username]
    end

    def get_users
      request_data
    end

    protected
    
    def collection_name
      'users'
    end

    def prepare_query
      settings = {
        "filter[fields][username]" => username,
        "limit"                    => 1
      }
      super(settings)
    end
  end
end