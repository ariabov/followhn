class HNSearch
  def prepare_query(settings)
    query  = "http://api.thriftdb.com/api.hnsearch.com/#{self.collection_name}/_search?"
    query += settings.collect{|k, v| "#{k}=#{v}"}.join('&')
    query
  end

  def individual_query
    query = "http://api.thriftdb.com/api.hnsearch.com/#{self.collection_name}/#{self.id}"
  end

  def request_data
    self.send_request do
      r = Mechanize.new.get(self.prepare_query)
      JSON.parse(r.body)["results"].collect do |item|
        item["item"].merge(created_at: item["item"]["create_ts"]).symbolize_keys
      end
    end
  end

  def single_request
    self.send_request do
      r = Mechanize.new.get(self.prepare_query).body
      j = JSON.parse(r)
      j.merge(created_at: j["create_ts"]).symbolize_keys
    end
  end

  def send_request(&block)
    begin
      begin
        yield
      rescue Mechanize::ResponseCodeError => e
        Rails.logger.error("#{e}: #{e.backtrace}")
        raise HNSearchServiceUnavailable if e.inspect.first(3).to_i == 503
        raise HNSearchNotFound           if e.inspect.first(3).to_i == 404
        raise HNSearchException
      end
    rescue HNSearchServiceUnavailable
      p 'HNSearchServiceUnavailable'
    rescue HNSearchNotFound
      nil
    rescue HNSearchException
      p 'HNSearchException'
    end
  end

  def collection_name
    raise MustBeDefinedInSubclass
  end
end

class HNSearchException            < StandardError; end
class HNSearchServiceUnavailable   < HNSearchException; end
class HNSearchNotFound             < HNSearchException; end