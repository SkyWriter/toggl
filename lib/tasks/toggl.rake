namespace :toggl do
  
  desc "update Toggl information"
  task :update => [:environment] do
    TogglSyncService.new.sync
  end
  
end