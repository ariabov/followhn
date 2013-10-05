module HN
  class Post
    def self.prepare_query(username)
      query = "http://api.thriftdb.com/api.hnsearch.com/items/_search?"
      query += {
        "filter[fields][username]" => prepare_username(username),
        "limit"                    => 20
      }.collect{|k, v| "#{k}=#{v}"}.join('&')
      query 
    end

    def self.for_username(username)
      r = Mechanize.new.get(prepare_query(username))
      JSON.parse(r.body)["results"].collect do |item|
        item["item"].merge(created_at: item["item"]["create_ts"]).symbolize_keys
      end
    end

    def self.prepare_username(usernames)
      usernames.respond_to?(:each) ? "(#{usernames.join(' ')})" : usernames
    end
  end
end