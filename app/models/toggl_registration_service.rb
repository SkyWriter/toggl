require 'net/http'
require 'json'

class TogglAPIEntry < Struct.new(:id, :issue_id, :started_at, :duration, :description)
end

# Responsible for fetching matching Toggl entries.
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

# Responsible for syncing Toggl with Redmine
class TogglRegistrationService
  
  def initialize(user, toggl_api_service)
    @user = user
    @toggl_api_service = toggl_api_service
  end
  
  def sync
    latest_toggl_entries = @toggl_api_service.get_toggl_entries
    puts "Latest Toggl entries: #{latest_toggl_entries.inspect}"
    return if latest_toggl_entries.empty?
    
    TogglTimeEntry.transaction do
      already_loaded_ids = TogglTimeEntry.with_ids(latest_toggl_entries.map(&:id)).map(&:id)
      puts "Already loaded IDS: #{already_loaded_ids.join(', ')}"
    
      latest_toggl_entries.each do |toggl_entry|
        next if already_loaded_ids.include?(toggl_entry.id)
        create_time_entry(@user, toggl_entry)
        TogglTimeEntry.register_synced_entry(toggl_entry.id)
      end
    end
  end
  
protected

  def create_time_entry(user, toggl_entry)
    issue = Issue.find(toggl_entry.issue_id)
    time_entry = TimeEntry.new(:project => issue.project, :issue => issue, :user => user, :spent_on => toggl_entry.started_at, :hours => toggl_entry.duration, :comments => toggl_entry.description)
    time_entry.save!
  end
  
end