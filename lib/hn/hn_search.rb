class HNSearch
  def prepare_query(settings)
    query  = "http://api.thriftdb.com/api.hnsearch.com/#{self.collection_name}/_search?"
    query += settings.collect{|k, v| "#{k}=#{v}"}.join('&')
    query
  end

  def request_data
    r = Mechanize.new.get(self.prepare_query)
    JSON.parse(r.body)["results"].collect do |item|
      item["item"].merge(created_at: item["item"]["create_ts"]).symbolize_keys
    end
  end

  def collection_name
    raise MustBeDefinedInSubclass
  end
end