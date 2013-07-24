# Responsible for toggl sync across all the users
class TogglSyncService
  
  def sync
    User.all.each do |user|
      toggl_api_key = user.custom_field_value(UserCustomField.find_by_name('Toggl API Key'))
      next if toggl_api_key.nil? || toggl_api_key.empty?
      
      api = TogglAPIService.new(toggl_api_key)
      time_registration_service = TogglTimeRegistrationService.new(user, api)
      time_registration_service.sync
    end
    
  end
  
end