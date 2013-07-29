# Responsible for syncing Toggl with Redmine
class TogglTimeRegistrationService
  
  def initialize(user, toggl_api_service)
    @user = user
    @toggl_api_service = toggl_api_service
  end
  
  def sync
    latest_toggl_entries = @toggl_api_service.get_toggl_entries
    return if latest_toggl_entries.empty?
    
    TogglTimeEntry.transaction do
      already_loaded_ids = TogglTimeEntry.with_ids(latest_toggl_entries.map(&:id)).map(&:id)
    
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
    time_entry = TimeEntry.new(:project => issue.project, :issue => issue, :user => user, :spent_on => toggl_entry.started_at, :comments => toggl_entry.description)
    time_entry.hours = toggl_entry.duration
    time_entry.save!
  end
  
end