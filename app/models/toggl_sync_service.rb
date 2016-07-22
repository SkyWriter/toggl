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

  def report(cc_mails, lang, time_interval)
    # Initialize a hash for keep users and their missmatch Toggl entries
    all_users_missmatch_toggl_entries = Hash.new

    User.active.each do |user|
      toggl_api_key = user.custom_field_value(UserCustomField.find_by_name('Toggl API Key'))
      next if toggl_api_key.blank?
      toggl_workspace = user.custom_field_value(UserCustomField.find_by_name('Toggl Workspace'))

      api = TogglAPIService.new(toggl_api_key, toggl_workspace)
      toggl_report_service = TogglReportService.new(api, time_interval)
      all_users_missmatch_toggl_entries[user] = toggl_report_service.sync
    end
    # Send all users missmatch toggl entry reports to CC mails.
    Mailer.toggl_missmatch_report_mail(cc_mails, lang, all_users_missmatch_toggl_entries).deliver
  end

end
