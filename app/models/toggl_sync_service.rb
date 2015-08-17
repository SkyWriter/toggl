# Responsible for toggl sync across all the users
class TogglSyncService

  def sync
    User.all.each do |user|
      next if !user.active? || user.locked?
      toggl_api_key = user.custom_field_value(UserCustomField.find_by_name('Toggl API Key'))
      next if toggl_api_key.nil? || toggl_api_key.empty?
      toggl_workspace = user.custom_field_value(UserCustomField.find_by_name('Toggl Workspace'))

      api = TogglAPIService.new(toggl_api_key, toggl_workspace)
      time_registration_service = TogglTimeRegistrationService.new(user, api)
      time_registration_service.sync
    end

  end

end
