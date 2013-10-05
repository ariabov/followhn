class HNSearch
  def prepare_query(settings)
    query  = "http://api.thriftdb.com/api.hnsearch.com/#{self.collection_name}/_search?"
    query += settings.collect{|k, v| "#{k}=#{v}"}.join('&')
    query
  end

  def request_data
    begin
      begin
        r = Mechanize.new.get(self.prepare_query)
        JSON.parse(r.body)["results"].collect do |item|
          item["item"].merge(created_at: item["item"]["create_ts"]).symbolize_keys
        end
      rescue Mechanize::ResponseCodeError => e
        Rails.logger.error("#{e}: #{e.backtrace}")
        raise HNSearchServiceUnavailable if e.inspect.first(3).to_i == 503
        raise HNSearchException
      end
    rescue HNSearchServiceUnavailable
      p 'HNSearchServiceUnavailable'
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