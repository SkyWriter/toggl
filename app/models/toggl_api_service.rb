require 'net/http'
require 'json'

# Responsible for fetching matching Toggl entries
class TogglAPIService
  
  def initialize(toggl_api_key)
    @toggl_api_key = toggl_api_key
  end
  
  def get_toggl_entries
    get_latest_toggl_entries_api_response["data"].map { |entry|
      if entry["description"] =~ /\s*#(\d+)\s*/
        TogglAPIEntry.new(entry["id"],
                          $1.to_i,
                          Time.parse(entry["start"]),
                          entry["duration"].to_f / 3600,
                          entry["description"].gsub(/\s*#\d+\s*/, '')
                          )
      else
        nil
      end
    }.compact
  end
  
protected
  
  def get_latest_toggl_entries_api_response
    uri = URI.parse 'https://www.toggl.com/api/v6/time_entries.json'

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    req = Net::HTTP::Get.new(uri.request_uri)
    req.basic_auth @toggl_api_key, 'api_token'

    res = http.request(req)
    JSON.parse(res.body)
  end
  
end
