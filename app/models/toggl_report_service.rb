# Responsible for syncing Toggl with Redmine
class TogglReportService

  def initialize(toggl_api_service, time_interval)
    @toggl_api_service = toggl_api_service
    @time_interval = time_interval
  end

  def sync
    missmatch_toggl_entries = @toggl_api_service.get_missmatch_toggl_entries(@time_interval)
  end
end
