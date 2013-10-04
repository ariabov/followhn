module HN
  class Post
    def self.for_username(username)
      r = Mechanize.new.get("http://api.thriftdb.com/api.hnsearch.com/items/_search?filter[fields][username]=#{username}")
      JSON.parse(r.body)["results"].collect do |item|
        item["item"].merge(created_at: item["item"]["create_ts"]).symbolize_keys
      end
    end
  end
end